#!/bin/bash

# Функция для завершения работы с ошибкой
function exit_with_error {
    echo "Ошибка: $1"
    exit 1
}

# Обновление списка пакетов
echo "Обновление списка пакетов..."
sudo apt update || exit_with_error "Не удалось обновить список пакетов."

# Установка необходимых зависимостей
echo "Установка зависимостей для pyenv и Python..."
sudo apt install -y llvm build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
|| exit_with_error "Не удалось установить зависимости."

# Проверка существования директории pyenv
if [ -d "$HOME/.pyenv" ]; then
    echo "Директория ~/.pyenv уже существует. Удаляем её..."
    rm -rf "$HOME/.pyenv" || exit_with_error "Не удалось удалить директорию ~/.pyenv."
fi

# Установка pyenv
echo "Установка pyenv..."
curl https://pyenv.run | bash || exit_with_error "Не удалось установить pyenv."

# Определение используемой оболочки
SHELL_NAME=$(basename "$SHELL")
SHELL_CONFIG_NAME=".${SHELL_NAME}rc"

# Настройка окружения для pyenv
if [[ "$SHELL_NAME" == "bash" || "$SHELL_NAME" == "zsh" ]]; then
    echo "Настройка окружения для ${SHELL_NAME}..."
    {
		echo 'SHELL_CONFIG_NAME=".${SHELL_NAME}rc"'
        echo 'export PYENV_ROOT="$HOME/.pyenv"'
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
        echo 'eval "$(pyenv init -)"'
        echo 'eval "$(pyenv virtualenv-init -)"'
    } >> ~/"$SHELL_CONFIG_NAME"
else
    echo "Неизвестная оболочка: $SHELL_NAME. Пожалуйста, добавьте настройки вручную."
fi

# Перезагрузка оболочки
echo "Перезагрузка оболочки..."
exec "$SHELL"
echo "Установка pyenv завершена."
