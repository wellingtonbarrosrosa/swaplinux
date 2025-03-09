#!/bin/bash

# Tamanho desejado do arquivo de swap em gigabytes
SWAP_SIZE_GB=2.5
SWAP_FILE="/swapfile"

# Função para verificar privilégios de root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root."
    exit 1
  fi
}

# Criar o arquivo de swap
create_swap() {
  echo "Criando arquivo de swap com ${SWAP_SIZE_GB}G em ${SWAP_FILE}..."
  fallocate -l ${SWAP_SIZE_GB}G ${SWAP_FILE} || { echo "Erro ao criar o arquivo de swap."; exit 1; }
  chmod 600 ${SWAP_FILE}
  mkswap ${SWAP_FILE}
}

# Ativar o arquivo de swap
enable_swap() {
  echo "Ativando o arquivo de swap..."
  swapon ${SWAP_FILE} || { echo "Erro ao ativar o arquivo de swap."; exit 1; }
}

# Atualizar o /etc/fstab
update_fstab() {
  echo "Atualizando /etc/fstab para incluir o arquivo de swap..."
  if ! grep -q "${SWAP_FILE}" /etc/fstab; then
    echo "${SWAP_FILE} swap swap defaults 0 0" >> /etc/fstab
  fi
}

# Desativar swap antigo (se necessário)
disable_old_swap() {
  echo "Desativando swaps antigos, se houver..."
  swapoff -a
}

# Remover swaps antigos do /etc/fstab
remove_old_swap_from_fstab() {
  echo "Removendo referências a swaps antigos do /etc/fstab..."
  sed -i.bak '/swap/d' /etc/fstab
}

# Confirmar swaps ativos
verify_swap() {
  echo "Verificando swaps ativos..."
  swapon --show
}

# Execução do script
check_root
disable_old_swap
remove_old_swap_from_fstab
create_swap
enable_swap
update_fstab
verify_swap

