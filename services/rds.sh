#!/bin/bash

# AWS rds


aws_rds_list_events() {
	aws rds describe-events
}


aws_rds_list_db_clusters() {
	aws_run_commandline 'aws rds describe-db-clusters \
	--query "*[].{\
		DBClusterIdentifier:DBClusterIdentifier,\
		DBClusterMembers:DBClusterMembers\
	}" --output table'
}

aws_rds_list_db_instances() {
	aws_run_commandline 'aws rds describe-db-instances \
	--query "*[].{\
		DBInstanceIdentifier:DBInstanceIdentifier,\
		Engine:Engine,Endpoint:Endpoint.Address,\
		DBInstanceClass:DBInstanceClass\
	}" --output table'
}


aws_rds_list_db_cluster_parameter_groups() {
	aws_run_commandline 'aws rds describe-db-cluster-parameter-groups \
	--query "*[].{\
		DBClusterParameterGroupName:DBClusterParameterGroupName,\
		DBParameterGroupFamily:DBParameterGroupFamily\
	}"'
}


aws_rds_list_db_parameter_groups() {
	aws_run_commandline "aws rds describe-db-parameter-groups \
	--query \"*[].{\
		DBParameterGroupName:DBParameterGroupName,
		DBParameterGroupFamily:DBParameterGroupFamily\
	}\" --output table"
}


aws_rds_create_cluster_snapshot() {
        aws_rds_db_cluster_name=$1
        aws_run_commandline \
        "
        aws rds create-db-cluster-snapshot \
		--db-cluster-identifier  ${aws_rds_db_cluster_name:?"aws_rds_db_cluster_name is unset or empty"} \
                --db-cluster-snapshot-identifier ${aws_rds_db_cluster_name}-`date '+%Y-%m-%d-%H-%M-%S'`
        "
}


aws_rds_create_cluster_snapshot_with_hint() {
	aws_rds_create_cluster_snapshot $( echo "$(peco_aws_list_db_clusters)" | peco )
}

aws_rds_create_instance_snapshot() {
	aws_rds_db_instance_name=$1

	aws_run_commandline \
	"
	aws rds create-db-snapshot \
    		--db-instance-identifier ${aws_rds_db_instance_name:?"aws_rds_db_instance_name is unset or empty"} \
    		--db-snapshot-identifier ${aws_rds_db_instance_name}-`date '+%Y-%m-%d-%H-%M-%S'`
    	"
}

aws_rds_create_instance_snapshot_with_hint() {
	aws_rds_create_instance_snapshot $(echo "$(peco_aws_list_db_instances)" | peco)
}

aws_rds_get_db_parameter() {
	db_parameter_group_name=$1
	echo Get all settings of the db parameter group \
		${db_parameter_group_name:?"db_parameter_group_name is unset or empty"}
	aws_run_commandline \
	"
	aws rds describe-db-parameters \
    		--db-parameter-group-name ${db_parameter_group_name}
    	"
}

aws_rds_get_db_parameter_with_hint() {
	aws_rds_get_db_parameter $(echo "$(peco_aws_list_db_parameter_groups)" | peco)

}


aws_rds_get_db_cluster_parameter() {
	db_cluster_parameter_group_name=$1

	echo Get all settings of the db parameter group \
		${db_cluster_parameter_group_name:?"db_cluster_parameter_group_name is unset or empty"}

	aws_run_commandline \
	"
	aws rds describe-db-cluster-parameters \
    		--db-cluster-parameter-group-name ${db_cluster_parameter_group_name}
    	"
}

aws_rds_get_db_cluster_parameter_with_hint() {
	aws_rds_get_db_cluster_parameter $(echo "$(peco_aws_list_db_cluster_parameter_groups)" | peco)

}


aws_rds_audit_log_setting() {
	db_cluster_parameter_group_name=$1
	echo Get the audit log settings for the db cluster parameter \
		${db_cluster_parameter_group_name:?"db_cluster_parameter_group_name is unset or empty"}

	aws_run_commandline \
	"
	aws rds describe-db-cluster-parameters \
    		--db-cluster-parameter-group-name ${db_cluster_parameter_group_name} \
    		--query 'Parameters[].{\
    			ParameterName:ParameterName,DataType:DataType,ParameterValue:ParameterValue,IsModifiable:IsModifiable\
    			} | [?starts_with(ParameterName, \`server_audit_log\`)] | [?IsModifiable == \`true\`]' --output table
    	"

}

aws_rds_audit_log_setting_with_hint() {
	aws_rds_audit_log_setting $(echo "$(peco_aws_list_db_cluster_parameter_groups)" | peco)
}


aws_rds_audit_log_disabled () {
	db_cluster_parameter_group_name=$1
	echo Disable audit log for the db cluster parameter \
		${db_cluster_parameter_group_name:?"db_cluster_parameter_group_name is unset or empty"}

	aws_run_commandline \
	"
	aws rds modify-db-cluster-parameter-group \
    		--db-cluster-parameter-group-name $db_cluster_parameter_group_name \
    		--parameters \"ParameterName=server_audit_logging,ParameterValue=0,ApplyMethod=immediate\" \
                 \"ParameterName=server_audit_logs_upload,ParameterValue=0,ApplyMethod=immediate\"
        "
}

aws_rds_audit_log_disabled_with_hint() {
	aws_rds_audit_log_disabled $(echo "$(peco_aws_list_db_cluster_parameter_groups)" | peco)
}