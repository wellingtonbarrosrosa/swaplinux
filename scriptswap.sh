#!/bin/bash

# Função para verificar privilégios de root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root."
    exit 1
  fi
}

# Função para pedir o tamanho do arquivo de swap
get_swap_size() {
  echo "Qual o tamanho desejado para o arquivo de swap (em GB)?"
  read SWAP_SIZE_GB
  if ! [[ "$SWAP_SIZE_GB" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Por favor, insira um valor numérico válido."
    exit 1
  fi
}

# Função para pedir o tamanho do bloco em MB
get_block_size() {
  echo "Qual o tamanho do bloco (em MB)? (Ex: 1 para 1MB, 4 para 4MB)"
  read BLOCK_SIZE_MB
  if ! [[ "$BLOCK_SIZE_MB" =~ ^[0-9]+$ ]]; then
    echo "Por favor, insira um valor numérico válido para o tamanho do bloco."
    exit 1
  fi
}

# Criar o arquivo de swap usando dd
create_swap() {
  SWAP_FILE="/swapfile"
  # Convertendo o tamanho do arquivo de GB para bytes
  SWAP_SIZE_BYTES=$((SWAP_SIZE_GB * 1024 * 1024 * 1024))
  echo "Criando arquivo de swap com ${SWAP_SIZE_GB}G em ${SWAP_FILE} usando blocos de ${BLOCK_SIZE_MB}MB..."
  
  # Usando dd para criar o arquivo de swap com o tamanho e o bloco especificados
  dd if=/dev/zero of=${SWAP_FILE} bs=${BLOCK_SIZE_MB}M count=$((SWAP_SIZE_BYTES / (BLOCK_SIZE_MB * 1024 * 1024))) status=progress || { echo "Erro ao criar o arquivo de swap."; exit 1; }
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
get_swap_size
get_block_size
disable_old_swap
remove_old_swap_from_fstab
create_swap
enable_swap
update_fstab
verify_swap
