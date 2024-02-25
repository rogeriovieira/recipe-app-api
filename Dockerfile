FROM python:3.9-alpine3.13
LABEL maintainer="capoeira.com.br"

# Exibe detalhes da execução Python
ENV PYTHONUNBUFFERED 1

# Copia os requisitos no arquivo de texto da maquina local para encaminhar /temp/requirements.txt
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Alterado para tru em docker-compose.yml
ARG dev=false

# Instala as dependências na maquina
# /py/bin//pip install --upgrade pip && \ -> Cria ambiente virtual para armazenar dependências, Atualiza o pip
# /py/bin/pip install -r /tmp/requirements.txt && \ -> Instala a lista de requisitos dentro da imagem docker
# adduser cria um usuário chamado "django-user" com privilégios menos que o root, sem senha e sem criar o diretorio home do usuário
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Atualiza a variavel de ambiente path dentro da imagem
# Dessa forma qualquer comando será executado automatixamente no ambiente virtual
ENV PATH="/py/bin:$PATH"

USER django-user