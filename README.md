# swiss-army-knife
Container that contains (haha) lots of tools we use on a daily basis, with SSH daemon

## Running on a single docker host

Building it local
```
podman build -t swiss-army-knife .
podman run -d -P --name  swiss-army-knife localhost/swiss-army-knife:latest
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
