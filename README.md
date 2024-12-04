# swiss-army-knife
Container that contains (haha) lots of tools we use on a frequently. Is normally Ubuntu-based image, but Alpine could be used with some caveats

## Quicky and Dirty
```
podman run -d -P --name swiss-army-knife docker.io/lsdopen/swiss-army-knife:latest
ssh root@localhost -p $(podman port swiss-army-knife | awk -F\: '{print $2}')
```

## Running on a single docker host

Building it local
```
podman build -t swiss-army-knife .

Run the container
```
podman run -d -P --name swiss-army-knife localhost/swiss-army-knife:latest
```

Stop container
```
podman stop swiss-army-knife
podman rm swiss-army-knife
```

## Running on Kubernetes

### Ephemeral Pod

This pod will run and exec you in. It will them remove itself after.

```
kubectl run -it --rm swiss-army-knife --image=lsdopen/swiss-army-knife:latest -- bash
```

### Imperative

```
kubectl create deployment swiss-army-knife --image=lsdopen/swiss-army-knife:latest
kubectl expose deployment swiss-army-knife
```

### Declarative

Create the file below and apply it to your namespace
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: swiss-army-knife
  name: swiss-army-knife
spec:
  replicas: 1
  selector:
    matchLabels:
      app: swiss-army-knife
  template:
    metadata:
      labels:
        app: swiss-army-knife
    spec:
      containers:
      - args: ["infinity"]
        command: ["sleep"]
        name: swiss-army-knife
        image: lsdopen/swiss-army-knife:latest
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: swiss-army-knife
  name: swiss-army-knife
spec:
  clusterIP: {}
  ports:
  - name: "8080"
    protocol: TCP
    targetPort: 8080
  selector:
    app: swiss-army-knife
  type: ClusterIP
```
