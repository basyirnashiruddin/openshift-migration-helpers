#!/bin/bash
IFS=$'\r\n' GLOBIGNORE='*' command eval  'PARAM=($(cat object.conf))'
NAMESPACE=$1
echo "EXPORTING PROJECT: $NAMESPACE"
mkdir -p export
for OBJ_TYPE in ${PARAM[@]}
do
	echo "PROCESS EXPORTING $OBJ_TYPE"
	EXECUTE=`oc get $OBJ_TYPE -n $NAMESPACE -o jsonpath="{.items[*]['metadata.name']}"`
	OBJECTS=$(echo $EXECUTE | tr " " "\n")
	mkdir -p export/$OBJ_TYPE
	for OBJ in $OBJECTS
	do
    	oc get $OBJ_TYPE/$OBJ -o yaml | yq eval 'del(.metadata.resourceVersion, .metadata.uid, .metadata.annotations, .metadata.creationTimestamp, .metadata.selfLink, .metadata.managedFields, .status, .metadata.ownerReferences, .image.metadata.resourceVersion, .image.metadata.uid, .image.metadata.annotations, .image.metadata.creationTimestamp)' - > export/$OBJ_TYPE/$OBJ.yml
	done
done