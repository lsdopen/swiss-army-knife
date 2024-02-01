# swiss-army-knife
Container that contains (haha) lots of tools we use on a daily basis, with SSH daemon

## Quicky and Dirty
```
podman run -d -P --name swiss-army-knife docker.io/lsdopen/swiss-army-knife:latest
ssh root@localhost -p $(podman port swiss-army-knife | awk -F\: '{print $2}')
```

## Running on a single docker host

Building it local
```
podman build -t swiss-army-knife .
podman run -d -P --name swiss-army-knife localhost/swiss-army-knife:latest
```

Get the port
```
podman port swiss-army-knife
22/tcp -> 0.0.0.0:44563
```

SSH in
```
ssh root@localhost -p 44563
Last login: Wed Sep  2 10:49:55 2020 from 127.0.0.1
root@ef8ce90c0ea5:~# 
```

Stop conatiner
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
kubectl create service nodeport swiss-army-knife --tcp=22:22
```

Determine the NodePort
```
kubectl get svc swiss-army-knife

NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
swiss-army-knife   NodePort   172.31.107.24   <none>        22:30316/TCP   99s
```

SSH onto any Kubernetes Node on that port
```
ssh root@worker-node-01 -p 30316
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
  ports:
  - name: 22-22
    nodePort: 30316
    port: 22
    protocol: TCP
    targetPort: 22
  selector:
    app: swiss-army-knife
  type: NodePort
```
