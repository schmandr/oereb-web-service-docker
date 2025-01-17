# Deploying OEREB Web Service in OpenShift

## Create and configure project

Create project:
```
oc new-project my-namespace
```

Set secret for pulling images from registry (optional):
```
oc create secret docker-registry dockerhub-pull-secret --docker-username=xy --docker-password=xy -n my-namespace
oc secrets link default dockerhub-pull-secret --for=pull -n my-namespace
```

Grant permissions for deploying from Jenkins running in a different namespace (optional);
replace JENKINS-NAMESPACE with the name of the namespace where Jenkins is deployed:
```
oc policy add-role-to-user edit system:serviceaccount:JENKINS-NAMESPACE:jenkins -n my-namespace
```

Grant permissions on project (optional):
```
oc policy add-role-to-user admin ... -n my-namespace
oc policy add-role-to-user view ... -n my-namespace
```

## Create secret

In a separate folder, create a file `oereb-web-service-secret.yaml`
containing a secret according to the following template.
Then run `oc apply -f path/to/oereb-web-service-secret.yaml -n my-namespace`.

```
kind: Secret
apiVersion: v1
metadata:
  name: oereb-web-service-secret
  labels:
    app: oereb-web-service
stringData:
  username: xy
  password: xy
```

## Create ConfigMap

In a separate folder, create a file `oereb-web-service-configmap.yaml`
containing a ConfigMap according to the following template.
(Replace HOSTNAME with the DB server host name or IP address.)
Then run `oc apply -f path/to/oereb-web-service-configmap.yaml -n my-namespace`.

```
kind: ConfigMap
apiVersion: v1
metadata:
  name: oereb-web-service-configmap
  labels:
    app: oereb-web-service
data:
  dburl: jdbc:postgresql://HOSTNAME/oereb_v2?sslmode=require
```

## Apply templae

```
oc process -f openshift/oereb-web-service.yaml --param-file=openshift/oereb-web-service_test.params | oc apply -f - -n my-namespace
```
