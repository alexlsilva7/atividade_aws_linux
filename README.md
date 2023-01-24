# Atividade Linux

Repositorio para a atividade de Linux, do programa de bolsas da Compass UOL.

**Objetivo**: Criar um ambiente AWS com uma instância EC2 e configurar o NFS para armazenar dados.

**Escopo**: A atividade incluirá a geração de uma chave pública de acesso, criação de uma instância EC2 com o sistema operacional Amazon Linux 2, geração de um endereço IP elástico e anexá-lo à instância EC2, liberação de portas de comunicação para acesso público, configuração do NFS, criação de um diretório com o nome do usuário no filesystem do NFS, instalação e configuração do Apache, criação de um script para validar se o serviço está online e enviar o resultado para o diretório NFS, e configuração da execução automatizada do script a cada 5 minutos.

**Referências**: [Documentação da Amazon Web Services](https://docs.aws.amazon.com/pt_br/index.html), [Documentação do Amazon Linux 2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Documentação do NFS](http://l.github.io/debian-handbook/html/pt-BR/sect.nfs-file-server.html), 

---
## Requisitos

### Instancia AWS:
- Chave pública para acesso ao ambiente
- Amazon Linux 2
    - t3.small
    - 16 GB SSD
- 1 Elastic IP associado a instancia
- Portas de comunicação liberadas
    - 22/TCP (SSH)
    - 111/TCP e UDP (RPC)
    - 2049/TCP/UDP (NFS)
    - 80/TCP (HTTP)
    - 443/TCP (HTTPS)

### Configurações Linux:

- Configurar o NFS entregue;
- Criar um diretorio dentro do filesystem do NFS com seu nome;
- Subir um apache no servidor - o apache deve estar online e rodando;
- Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretorio no nfs;
    - O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou offline;
    - O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;
    - Execução automatizada do script a cada 5 minutos.

---

## Instruções de Execução

### Gerar uma chave pública de acesso na AWS e anexá-la à uma nova instância EC2.
- Acessar a AWS na pagina do serviço EC2, e clicar em "Pares de chaves" no menu lateral esquerdo.
- Clicar em "Criar par de chaves".
- Inserir um nome para a chave e clicar em "Criar par de chaves".
- Salvar o arquivo .pem gerado em um local seguro.
- Clicar em "Instâncias" no menu lateral esquerdo.
- Clicar em "Executar instâncias".
- Configurar as Tags da instância (Name, Project e CostCenter) para instâncias e volumes.
- Selecionar a imagem Amazon Linux 2 AMI (HVM), SSD Volume Type.
- Selecionar o tipo de instância t3.small.
- Selecionar a chave gerada anteriormente.
- Colocar 16 GB de armazenamento gp2 (SSD).
- Clicar em "Executar instância".


### Alocar um endereço IP elástico à instância EC2.

- Acessar a AWS na pagina do serviço EC2, e clicar em "IPs elásticos" no menu lateral esquerdo.
- Clicar em "Alocar endereço IP elástico".
- Selecionar o ip alocado e clicar em "Ações" > "Associar endereço IP elástico".
- Selecionar a instância EC2 criada anteriormente e clicar em "Associar".

### Configurar gateway de internet.

- Acessar a AWS na pagina do serviço VPC, e clicar em "Gateways de internet" no menu lateral esquerdo.
- Clicar em "Criar gateway de internet".
- Definir um nome para o gateway e clicar em "Criar gateway de internet".
- Selecionar o gateway criado e clicar em "Ações" > "Associar à VPC".
- Selecionar a VPC da instância EC2 criada anteriormente e clicar em "Associar".

### Configurar rota de internet.

- Acessar a AWS na pagina do serviço VPC, e clicar em "Tabelas de rotas" no menu lateral esquerdo.
- Selecionar a tabela de rotas da VPC da instância EC2 criada anteriormente.
- Clicar em "Ações" > "Editar rotas".
- Clicar em "Adicionar rota".
- Configurar da seguinte forma:
    - Destino: 0.0.0.0/0
    - Alvo: Selecionar o gateway de internet criado anteriormente
- Clicar em "Salvar alterações".

### Configurar regras de segurança.
- Acessar a AWS na pagina do serviço EC2, e clicar em "Segurança" > "Grupos de segurança" no menu lateral esquerdo.
- Selecionar o grupo de segurança da instância EC2 criada anteriormente.
- Clicar em "Editar regras de entrada".
- Configurar as seguintes regras:
    Tipo | Protocolo | Intervalo de portas | Origem | Descrição
    ---|---|---|---|---
    SSH | TCP | 22 | 0.0.0.0/0 | SSH
    TCP personalizado | TCP | 80 | 0.0.0.0/0 | HTTP
    TCP personalizado | TCP | 443 | 0.0.0.0/0 | HTTPS
    TCP personalizado | TCP | 111 | 0.0.0.0/0 | RPC
    UDP personalizado | UDP | 111 | 0.0.0.0/0 | RPC
    TCP personalizado | TCP | 2049 | 0.0.0.0/0 | NFS
    UDP personalizado | UDP | 2049 | 0.0.0.0/0 | NFS

### Configurar o NFS com o IP fornecido

- Criar um novo diretório para o NFS usando o comando `sudo mkdir /mnt/nfs`.
- Montar o NFS no diretório criado usando o comando `sudo mount IP_OU_DNS_DO_NFS:/ /mnt/nfs`.
- Verificar se o NFS foi montado usando o comando `df -h`.
- Configurar o NFS para montar automaticamente no boot usando o comando `sudo nano /etc/fstab`.
- Adicionar a seguinte linha no arquivo `/etc/fstab`:
    ```
    IP_OU_DNS_DO_NFS:/ /mnt/nfs nfs defaults 0 0
    ```
- Salvar o arquivo `/etc/fstab`.
- Criar um novo diretório para o usuário alexlopes usando o comando `sudo mkdir /mnt/nfs/alexlopes`.

### Configurar o Apache.

- Executar o comando `sudo yum update -y` para atualizar o sistema.
- Executar o comando `sudo yum install httpd -y` para instalar o apache.
- Executar o comando `sudo systemctl start httpd` para iniciar o apache.
- Executar o comando `sudo systemctl enable httpd` para habilitar o apache para iniciar automaticamente.
- Executar o comando `sudo systemctl status httpd` para verificar o status do apache.
- Configurações adicionais do apache podem ser feitas no arquivo `/etc/httpd/conf/httpd.conf`.
- para parar o apache, executar o comando `sudo systemctl stop httpd`.

### Configurar o script de validação.

- Crie um novo arquivo de script usando o comando "nano script.sh".
- Adicione as seguintes linhas de código no arquivo de script:
    ```bash
    #!/bin/bash
    # Script que verifica o status do serviço httpd e salva o resultado em um arquivo no diretório /mnt/nfs/alex
    
    DATA=$(date +%d/%m/%Y)
    HORA=$(date +%H:%M:%S)
    SERVICO="httpd"
    STATUS=$(systemctl is-active $SERVICO)
   
    if [ $STATUS == "active" ]; then
        MENSAGEM="O $SERVICO está ONLINE"
        echo "$DATA $HORA - $SERVICO - active - $MENSAGEM" >> /mnt/nfs/alexlopes/online.txt
    else
        MENSAGEM="O $SERVICO está offline"
        echo "$DATA $HORA - $SERVICO - inactive - $MENSAGEM" >> /mnt/nfs/alexlopes/offline.txt
    fi
    ```
- Salve o arquivo de script.
- Execute o comando `chmod +x script.sh` para tornar o arquivo de script executável.
- Execute o comando `./script.sh` para executar o script.

### Configurar a execução do script de validação a cada 5 minutos.

#### Escolha uma das formas a seguir:
<details>
<summary>Usando o crontab (mais simples)</summary>

### Configurar o cronjob.

- Execute o comando `crontab -e` para editar o cronjob.
- Adicione a seguinte linha de código no arquivo de cronjob:
    ```bash
    */5 * * * * /home/ec2-user/script.sh
    ```
- Salve o arquivo de cronjob.
- Execute o comando `crontab -l` para verificar se o cronjob foi configurado corretamente.

</details>

<details>
<summary>Usando o systemd (mais complexo)</summary>

### Configurar o serviço systemd.
- Crie um novo arquivo de serviço usando o comando `sudo nano /etc/systemd/system/validate_apache.service`.
- Adicione as seguintes linhas de código no arquivo de serviço:
    ```bash
    [Unit]
    Description=Validate apache service
    
    [Service]
    Type=simple
    ExecStart=/home/ec2-user/script.sh
    Restart=on-failure
    RestartSec=5
    
    [Install]
    WantedBy=multi-user.target
    ```
- Salve o arquivo de serviço.
- Execute o comando `sudo systemctl daemon-reload` para recarregar o systemd.
- Execute o comando `sudo systemctl start validate_apache` para iniciar o serviço.
- Execute o comando `sudo systemctl enable validate_apache` para habilitar o serviço para iniciar automaticamente.
- Execute o comando `sudo systemctl status validate_apache` para verificar o status do serviço.

### Configurar o timer systemd.
- Crie um novo arquivo de timer usando o comando `sudo nano /etc/systemd/system/validate_apache.timer`.
- Adicione as seguintes linhas de código no arquivo de timer:
    ```bash
    [Unit]
    Description=Validate apache timer
    
    [Timer]
    OnBootSec=5min
    OnUnitActiveSec=5min
    Unit=validate_apache.service

    [Install]
    WantedBy=multi-user.target
    ```
- Salve o arquivo de timer.
- Execute o comando `sudo systemctl daemon-reload` para recarregar o systemd.
- Execute o comando `sudo systemctl start validate_apache.timer` para iniciar o timer.
- Execute o comando `sudo systemctl enable validate_apache.timer` para habilitar o timer para iniciar automaticamente.
- Execute o comando `sudo systemctl status validate_apache.timer` para verificar o status do timer.

</details>

### Exemplo de user data para criação de instância EC2.

```bash
#!/bin/bash
timedatectl set-timezone America/Sao_Paulo
yum update -y
yum install -y git
cd /
git clone https://github.com/alexlsilva7/atividade_aws_linux.git

#NFS
mkdir -p /mnt/nfs
sudo mount IP_OU_DNS_DO_NFS:/ /mnt/nfs
echo "IP_OU_DNS_DO_NFS:/ /mnt/nfs nfs defaults 0 0" >> /etc/fstab

# Apache
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Configurar Script pelo systemd
sudo cp /atividade_aws_linux/validate_apache.service /etc/systemd/system/
sudo cp /atividade_aws_linux/validate_apache.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start validate_apache
sudo systemctl enable validate_apache
sudo systemctl start validate_apache.timer
sudo systemctl enable validate_apache.timer
```

- Substituir o IP_OU_DNS_DO_NFS pelo IP ou DNS do servidor NFS.