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
DST_REG=${destination_registry}
DST_TOKEN=${destination_token}

podman login -u admin -p $SRC_TOKEN $SRC_REG --tls-verify=false
podman login -u admin -p $DST_TOKEN $DST_REG --tls-verify=false

echo "Starting Image Migration"

ISTAGS=`oc get is -o jsonpath="{range .items[*]}{@.metadata.name}{':'}{@.status.tags[0].tag}{'\n'}{end}" -n $NAMESPACE --token=$SRC_TOKEN`
for ISTAG in $ISTAGS
do
        IZ=${ISTAG: -1}
        if [ "$IZ" != ":" ]; then
                echo "Migrating: $ISTAG"
                oc image mirror -a $XDG_RUNTIME_DIR/containers/auth.json $SRC_REG/$NAMESPACE/$ISTAG $DST_REG/$NAMESPACE/$ISTAG --insecure=true
        fi
done