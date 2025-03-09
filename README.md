Script para Gerenciamento de Swap no Linux
Este script tem como objetivo automatizar a criação, ativação e configuração de um arquivo de swap no Linux. Ele também desativa qualquer swap antigo, atualiza o arquivo /etc/fstab para garantir que o swap seja montado automaticamente após reinicializações, e verifica a configuração de swap ativa.

Funcionalidades
Verificação de Privilégios de Root: O script verifica se está sendo executado com privilégios de superusuário (root).
Criação de Arquivo de Swap: Cria um arquivo de swap de tamanho configurável (por padrão, 2.5 GB) usando o comando fallocate.
Ativação do Swap: Ativa o arquivo de swap recém-criado utilizando o comando swapon.
Atualização do /etc/fstab: Adiciona automaticamente o arquivo de swap ao arquivo /etc/fstab para garantir que ele seja montado no início de cada reinicialização.
Desativação de Swap Antigo: Desativa todos os swaps ativos no sistema.
Remoção de Referências Antigas: Remove quaisquer entradas antigas de swap do arquivo /etc/fstab.
Verificação de Swap Ativo: Exibe a lista de swaps ativos no sistema para confirmação da criação e ativação do novo swap.
Como Usar
Clonar o repositório: Clone este repositório em seu ambiente Linux:

bash
Copiar
Editar
git clone https://github.com/seuusuario/seurepositorio.git
cd seurepositorio
Dar permissões de execução ao script: O script precisa de permissões de execução. Altere as permissões com o seguinte comando:

bash
Copiar
Editar
chmod +x swap.sh
Executar o script: Execute o script com privilégios de root para garantir que ele possa realizar todas as operações necessárias:

bash
Copiar
Editar
sudo ./swap.sh
Personalização
O tamanho do arquivo de swap pode ser alterado modificando a variável SWAP_SIZE_GB no início do script. O valor padrão é 2.5 GB.
Exemplo de Saída
Ao executar o script, você verá as seguintes mensagens de progresso:

bash
Copiar
Editar
Criando arquivo de swap com 2.5G em /swapfile...
Ativando o arquivo de swap...
Atualizando /etc/fstab para incluir o arquivo de swap...
Desativando swaps antigos, se houver...
Removendo referências a swaps antigos do /etc/fstab...
Verificando swaps ativos...
Notas
Certifique-se de que o seu sistema tenha espaço suficiente em disco para criar o arquivo de swap.
O script desativa qualquer swap existente, então, se você tem uma partição de swap ativa, ela será desativada e removida do arquivo /etc/fstab.
Contribuições
Se você encontrar algum bug ou quiser sugerir melhorias, fique à vontade para abrir uma issue ou enviar um pull request.

