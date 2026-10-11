# Smart Scent ERP — builds

Compiled builds only (no source). Each release holds `jannah-x.y.z.tar.gz`, its signature and `latest.json`.

Install on a new Ubuntu 26.04 server (as root):

```
curl -fsSL https://raw.githubusercontent.com/diaarama475-max/jannah-scent-smart-build/main/get.sh | bash -s -- --tunnel-token <TOKEN>
```

Installed servers check for new builds every 15 minutes and install them in their night window, with a database
backup first and automatic roll back.
