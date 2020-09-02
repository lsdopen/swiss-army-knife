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
