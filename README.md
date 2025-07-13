# VAGRANT NO WINDOWS
Este projeto utiliza o Vagrant para criar e gerenciar ambientes de máquinas virtuais de forma automatizada. Ideal para testes locais, desenvolvimento ou simulações de infraestrutura.


## Documentação
- [Vagrant](https://developer.hashicorp.com/vagrant)
- [Vagrant Boxes](https://portal.cloud.hashicorp.com/vagrant/discover)
- [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Configuração adicional do Virtual Box - modifyvm](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifyvm.html)
- [Alterar espaço em disco](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifymedium.html)

## Vagrant
- O que é?
    - O Vagrant é uma ferramenta CLI criada em Ruby e pertencente a empresa [Hashcorp](https://www.hashicorp.com/pt) capaz de gerenciar e provisionar VMs. 
    - Em outras palavras, o Vagrant é uma ferramenta que facilita a criação e configuração de ambientes virtuais usando arquivos de configuração legíveis e reutilizáveis. Ele permite que você defina máquinas com sistemas operacionais, rede, memória, CPUs e scripts de provisionamento com facilidade.

- Por quê o Vagrant?
    - Porque com ela é possível escolher um provedor como o Virtual Box e gerencia-lo através de scripts de provisionamento, criando assim seu próprio ambiente de desenvolvimento.
    - Assim como o `Docker`, ele possui um Hub/Registry com imagens já prontas chamadas de `Boxes` criadas por outros usuários e disponibilizadas para a comunidade. Estas boxes são definidas em seu arquivo `Vagrantfile` conforme sua necessidade.
    - Caso você não tenha essa box em seu sistema, ela será baixada automaticamente.

- Casos de uso.
    - Criação de nós de Kubernetes, Docker Swarm, Ansible e outras aplicações em seu ambiente de desenvolvimento.

## Instalação e Configuração
Antes de iniciar a instalação, confirme se o seu `Hyper-V` está desabilitado em `Ativar ou Desativar Recursos do Windows`. Ele habilitado costuma causar conflito durante a execução do Vagrant. 


- Virtual Box
    - Instalação simples. Faça o Download da última versão e next, next...
    - No momento a versão instalada nesse passo a passo é a `7.1.10` em um Windows 11.

- Pode requerer a instalação do Microsoft Visual C++ 2019+. Clique [AQUI](https://learn.microsoft.com/pt-br/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022) para seguir para a página de download e baixar a versão compatível com seu Sistema Operacional. Aqui foi baixado o instalador `vc_redist.x64.exe`

- Vagrant
    - Acesse esse [link](https://developer.hashicorp.com/vagrant/install) e baixe o instalador de acordo com a versão do seu sistema operacional.
    - Instalação simples. Faça o Download da última versão e next, next...
    - Abra seu terminal e digite `vagrant vbguest --version` para saber se completou a instalação e a versão instalada. No momento a versão instalada nesse passo a passo é a `2.4.7` em um Windows 11.
    - Caso ocorra algum erro de plugin, ele poderá estar relacionado ao `vbguest` e sua versão, podendo ser a respeito de compatibilidade com o provider do Virtual Box, às vezes precisando ser apontado, ou plugin adicional que precisa ser instalado por ele.

## Como usar
Para começar, acesse o diretório `vagrant-starter`.
```bash
# Iniciar VM
vagrant up

# Acessar
vagrant ssh

# Deslogar
exit

# Pausar
vagrant halt

# Despausar
vagrant resume

# Iniciar ou Reiniciar sem refazer o provisionamento
vagrant up --no-provision
vagrant reload --no-provision

# Reiniciar após alterar arquivos de provisionamento
vagrant reload

# Remover
vagrant destroy

# Remover cash .vagrant
rm .vagrant

# Por padrão, ao iniciar uma VM através do vagrant todos os arquivos do diretório são copiados para dentro da VM no diretório /vagrant.

# Caso não consiga fazer cópia de arquivos da VM:Localhost ou Localhost:VM será preciso instalar um plugin através do terminal. Se der erro de 'Unable to resolve dependency: user requested 'vargrant-scp (> 0)', execute novamente o comando abaixo.
vagrant plugin install vargrant-scp

# Cópia de Arquivo VM:LOCALHOST
scp ARQUIVO PATH
#EXEMPLO
TOUCH texto.txt
scp texto.txt vagrant-starter 

# Status globais como ID das VMs sendo executados.
vagrant global-status

# Saída do comando global-status (id, nome, directory serão diferentes em seu local)
id       name    provider   state   directory
------------------------------------------------------------------------
de92113  starter virtualbox running C:/Projetos/Vagrant/vagrant-starter 


# SSH de qualquer diretório -> vagrant ssh id
vagrant ssh de92113


# Cópia de Arquivo LOCALHOST:VM

# Todo arquivo criado direto na pasta raiz de onde foi executado o provisionamento, automaticamente será copiado para dentro do diretório /vagrant.

# Acesse o diretório raiz 
vagrant scp README.md  ID_VM:/tmp 
```

## Execução das VM
As boxes criadas pela comunidade possuem o usuário `vagrant` além do root. Para verificar as permissões de grupo que ele está incluso, basta acessar a VM e executar o comando abaixo.
```bash
# Permissões de grupo
cat /etc/group | grep vagrant

# Usuários
cat /etc/passwd | grep bash
```

`Configuração de rede:` Conforme definido no arquivo de provisionamento o ip 192.168.56.5 para esta VM pode ser conferido através deste comando. `eth0` refere-se a rede interna do Virtual Box e o `eth1` será a rede bridge por onde redes externas, como seu `local` conectam-se a sua VM.
```bash
ip -4 a
``` 

`Docker:` Para testar se a sua VM se conecta através do IP definido e porta externa liberada, basta acessá-la e criar um container, acessando através do `IP:Porta`. Execute o comando abaixo e acesse-o através do IP `http://192.168.56.5:8080`
```bash
docker container run -d -p 8080:80 nginx
```

`forwarded_port`: ele mapeia uma porta da máquina física (seu localhost) para uma porta da máquina virtual (guest - VM). E aí entra o detalhe importante: duas máquinas virtuais não podem compartilhar a mesma porta do host. Por exemplo, `vm.vm.network :forwarded_port, guest: 80, host: 8080`, dessa forma você está dizendo: "Tudo que chegar na porta 8080 da minha máquina física (host), quero que vá pra porta 80 da VM que estiver escutando aqui. Se você fizer isso para duas ou mais VMs, o Vagrant não consegue completar a operação porque a porta 8080 já está ocupada pelo mapeamento da primeira VM."


## Iniciar 2+ VMs 
O diretório `vagrant-multi-vm` contém o script para executar mais de uma VM ao mesmo tempo. Os comandos de execução serão os mesmos.
 
# Adicional - Criar a própria box
OBS.: Precisa validar, mas o passo a passo é esse.
```bash
## Criar do zero uma Box do windows
1. Baixar a ISO do Windows
2. Criar VM e instalar a ISO
3. Alterar nome da VM para VagrantPC ou Vagrant
4. Criar usuario e senha vagrant
5. No terminal, navegue até o diretório onde a máquina virtual foi criada.
6. Opcional: Instalar WinRm e Atualizar o PowerShell para futura configuração do Ansible

7. Execute o seguinte comando para criar a Box do Vagrant:
- Precisa estar com a VM desligada. Caso contrário o comando irá forçar o desligamento.
- `vagrant package --base nome_da_sua_vm_no_virtualbox`
- Isso criará um arquivo package.box no diretório atual.
- Ex.: `vagrant package --base Vagrant`
- A exportação da VM é um pouco demorada (Depndendo da configuração do PC).
- Logo após exportar, será realizada a compressão do arquivo que levará um tempo também.
- O Arquivo final terá em média 5GB a 6GB mais ou menos.

8. Adicione a box à sua biblioteca do Vagrant:
- Execute o seguinte comando para adicionar a “box” à sua biblioteca do Vagrant:
- `vagrant box add windowsserver2019 package.box`
- Isso adicionará a box do Windows 10 à sua biblioteca LOCAL do Vagrant com o nome windowsserver2019.

9. Crie um Vagrantfile para iniciar a máquina virtual:
- `vagrant init windowsserver2019`
```
