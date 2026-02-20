FROM ruby:3.3

# Pacotes para compilar gems nativas + pg
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  pkg-config \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Bundler em modo "limpo" e previsível
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="production" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# (Opcional) evita atualizar RubyGems automaticamente e mudar comportamentos
# Se quiser atualizar, faça manualmente quando precisar
RUN gem install bundler

# Cache: copia só Gemfile primeiro para aproveitar camadas
COPY Gemfile Gemfile.lock ./

# Instala dependências (vai cachear bem no build)
RUN bundle install

# Depois copia o resto do projeto
COPY . .

EXPOSE 3000

CMD ["bash", "-lc", "bundle exec rails s -b 0.0.0.0 -p 3000"]