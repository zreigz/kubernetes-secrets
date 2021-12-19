# Kubernetes secrets API example

This git repo illustrates a small application which can access kubernetes
secrets.

## Build small application

To test the application build the docker image which builds the small application.
Run the command:

```bash
docker build -t kubernetes-secret .
```

```bash
docker tag kubernetes-secret:latest kubernetes-secret:v0.0.1
```

## Deploy to Docker kubernetes

Get the Docker desktop context.

```bash
kubectl config get-contexts
kubectl config use-context docker-desktop
```

Apply the kubernetes files to the cluster:

```bash
kubectl apply -f kubernetes
```

Check that on deployment

```bash
kubectl get deployments -n mynamespace
```

Check on the pods

```bash
kubectl get pods -n mynamespace
```

Get the logs from the pod

```bash
kubectl logs kubernetes-secrets-xxxxx  -n mynamespace
```

## Clean up after

To clean up after run:

```bash
kubectl delete secret mysecret -n mynamespace
kubectl delete deployment kubernetes-secrets -n mynamespace
kubectl delete role secret-reader -n mynamespace
kubectl delete rolebinding read-secrets -n mynamespace
kubectl delete serviceaccount my-service-account -n mynamespace
```
