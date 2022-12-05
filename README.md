# openshift-migration-helpers

For getting all objects in a namespace:

./getdeploy.sh {namespace}
- Please make sure the namespace is correct
- Please define the object that will be migrated at object.conf file.
- Please install yq
- Please install oc client
- Please log in to your existing openshift cluster

For migrating all the latest images from one cluster to another cluster with a specific namespace

./migrateimage.sh {namespace}
- Please make sure the namespace is correct
- Please make sure the namespace is available at the destination
- Please define the source registry and token at access.conf
- Please define the destination registry and token at access.conf
