## Script simples que usei durante o treinamento descomplicando o k8s da LinuxTips para backup/snapshot do meu ambiente local
<br />

#### Linha do crontab usado em teste: Use de acordo com sua necessidade olhe a var PATH do(s) node(s) master(s) onde roda o etcd ajuste seu diretório pode brincar as variáveis de certificado e o member list peguei do manifesto kube-apiserver.yaml ta tudo abaixo<br />

```console
echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```

#### Pegando valores de chaves e membros
```console
cat /etc/kubernetes/manifests/kube-apiserver.yaml|egrep -i etcd
#Retorno do comando acima:
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt  # Var ETCDCTL_CACERT no script
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt #var ETCDCTL_CERT no script
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key #var ETCDCTL_KEY no script
    - --etcd-servers=https://127.0.0.1:2379 # var membro no script
```

####Linha do meu crontab de teste
```console
45 15 * * * PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin && /opt/etcdbackup/script/backupetcd.sh 2>&1 > /tmp/log.backupetcd.sh

```

<hr />

## Restore <br />

Testei o snapshot gerado por este script com este processo do <a href=https://github.com/mmumshad>Mumshad Mannambeth</a> créditos a ele :clap::clap: <br /><a href=https://github.com/mmumshad/kubernetes-cka-practice-test-solution-etcd-backup-and-restore>Restore ETCD</a> <br />

#### Ressalva:
* Como no script eu faço um teste de status do snapshot é necessário adicionar a flag --skip-hash-check=true pq o status abre o snap.
