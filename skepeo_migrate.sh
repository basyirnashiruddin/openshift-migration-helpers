#!/bin/bash
file="./access.conf"
while IFS='=' read -r key value
do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
done < "$file"

NAMESPACE=$1
SRC_REG=${source_registry}
SRC_TOKEN=${source_token}
SRC_USER=${source_user}
DST_REG=${destination_registry}
DST_TOKEN=${destination_token}
DST_USER=${destination_user}

skopeo login --username $SRC_USER --password $SRC_TOKEN $SRC_REG --tls-verify=false
skopeo login --username $DST_USER --password $DST_TOKEN $DST_REG --tls-verify=false

echo "Starting Image Migration"

ISTAGS=`oc get istag -o jsonpath="{range .items[*]}{@.metadata.name}{'\n'}{end}" -n $NAMESPACE --token=$SRC_TOKEN`
for ISTAG in $ISTAGS
do
        echo "Migrating: $ISTAG"
        skopeo sync --src docker $SRC_REG/$NAMESPACE/$ISTAG --src-tls-verify=false --dest docker $DST_REG/$NAMESPACE/$ISTAG --dest-tls-verify=false
done