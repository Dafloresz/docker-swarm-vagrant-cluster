# 🐳 Cluster Docker Swarm Local com Vagrant

Projeto desenvolvido como desafio de projeto da [DIO](https://www.dio.me/), com o objetivo de criar e automatizar um cluster local utilizando **Vagrant, VirtualBox, Docker e Docker Swarm**.

A infraestrutura é composta por quatro máquinas virtuais Ubuntu, sendo uma responsável pelo gerenciamento do cluster e três atuando como workers.

## 🎯 Objetivo

Criar um ambiente local capaz de simular uma infraestrutura distribuída utilizando Docker Swarm, automatizando desde a criação das máquinas virtuais até a configuração do cluster.

O projeto contempla:

* Criação automatizada de 4 máquinas virtuais;
* Configuração de IPs privados fixos;
* Instalação automatizada do Docker;
* Inicialização automática do Docker Swarm;
* Configuração automática dos workers;
* Execução de serviços distribuídos entre os nós;
* Escalonamento de réplicas;
* Recuperação automática de containers;
* Publicação de serviços através da Routing Mesh.

## 🏗️ Arquitetura

```text
                         Docker Swarm
                              │
                    ┌─────────┴─────────┐
                    │                   │
              ┌─────▼─────┐       Rede privada
              │   master  │       192.168.56.0/24
              │ .10       │
              │ Manager   │
              │ Leader    │
              └─────┬─────┘
                    │
          ┌─────────┼─────────┐
          │         │         │
     ┌────▼────┐ ┌──▼─────┐ ┌─▼──────┐
     │ node01  │ │ node02 │ │ node03 │
     │ .11     │ │ .12    │ │ .13    │
     │ Worker  │ │ Worker │ │ Worker │
     └─────────┘ └────────┘ └────────┘
```

### Nós do cluster

| Hostname | IP            | Função           |
| -------- | ------------- | ---------------- |
| master   | 192.168.56.10 | Manager / Leader |
| node01   | 192.168.56.11 | Worker           |
| node02   | 192.168.56.12 | Worker           |
| node03   | 192.168.56.13 | Worker           |

## 🛠️ Tecnologias utilizadas

* **Vagrant** — automação das máquinas virtuais
* **VirtualBox** — hypervisor utilizado para execução das VMs
* **Ubuntu 22.04** — sistema operacional das máquinas
* **Docker** — containerização
* **Docker Swarm** — orquestração dos containers
* **Bash** — scripts de provisionamento
* **Ruby** — configuração do Vagrantfile

## 📁 Estrutura do Projeto
 
```text
├── Vagrantfile         # Define as 4 VMs (hostname, IP, CPU, memória)
├── install_docker.sh   # Instala o Docker em todas as VMs
├── init_swarm.sh       # Inicia o Swarm no master e gera o comando de join
├── join_swarm.sh       # Faz os workers entrarem no cluster
└── .gitignore
```


### Pré-requisitos

Instale previamente:

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://developer.hashicorp.com/vagrant/)
* Git

## 🚀 Como executar

```bash
git clone <https://github.com/Dafloresz/docker-swarm-vagrant-cluster>
cd "Cluster Swarm Local"
vagrant up
```

O Vagrant irá:

1. Criar as quatro máquinas virtuais;
2. Configurar os IPs privados;
3. Instalar o Docker;
4. Inicializar o Swarm no `master`;
5. Gerar o comando de entrada dos workers;
6. Fazer os workers ingressarem automaticamente no cluster.

## 🔎 Verificando o cluster

Entre no manager:

```bash
vagrant ssh master
```

Verifique os nós:

```bash
docker node ls
```

Resultado esperado:

```text
HOSTNAME   STATUS   AVAILABILITY   MANAGER STATUS
master     Ready    Active         Leader
node01     Ready    Active
node02     Ready    Active
node03     Ready    Active
```

## 🧪 Testes realizados
 
### Criar e escalar um serviço
 
```bash
docker service create --name web nginx
docker service scale web=4
docker service ps web
```
 
O Swarm distribui as réplicas entre os nós disponíveis.
 
### Publicar com Routing Mesh
 
```bash
docker service update --publish-add 8080:80 web
curl http://192.168.56.10:8080
curl http://192.168.56.11:8080
```
 
O serviço responde em qualquer nó do cluster, mesmo naqueles que não executam uma réplica.
 
### Recuperação automática (self-healing)
 
```bash
docker rm -f <container_id>
```
 
Ao remover um container manualmente, o Swarm detecta a diferença entre o estado atual e o desejado (4 réplicas) e cria uma nova task automaticamente.

## 🧠 O que pratiquei
 
- Infrastructure as Code com Vagrant
- Provisionamento automatizado com Bash
- Redes privadas entre VMs
- Docker Swarm: nodes, services, tasks e réplicas
- Scheduler e *desired state*
- Routing Mesh e publicação de portas

## 🔐 Segurança
 
O token de join do Swarm é gravado em um arquivo local (`worker_join_command`) e **não é versionado**:
 
```gitignore
worker_join_command
.vagrant/
```

## 👨‍💻 Autor

**Thiago Figueiredo Piazentin**

Projeto desenvolvido para fins de estudo, prática de DevOps e participação em desafio de projeto da DIO.
