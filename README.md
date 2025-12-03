# 🌵 Pindorama API


(delete)Uma API RESTful desenvolvida com Ruby on Rails, utilizando PostgreSQL como banco de dados e Docker para garantir o desenvolvimento da aplicação Pindorama, uma aplicação web, especializada em difundir conteúdos sobre o Patrimônio Cultural Imaterial Brasileiro.


## 🚀 Tecnologias

Este projeto foi construído com as seguintes tecnologias

    Ruby on Rails: Age como uma api fornecendo os serviços. 

    PostgreSQL: Sistema de gerenciamento de banco de dados relacional.

    Docker & Docker Compose: Para gerenciar e executar as apis em contêineres.0

## 📌 Serviços que a api apresenta

- CRUD de artigos e eventos
- Mapa brasileiro de acordo a localização dos artigos

## ⚙️ Pré-requisitos

Para rodar este projeto, você precisa ter as seguintes ferramentas instaladas em sua máquina:

- **Git**: Para clonar o repositório.
- **Docker**: A plataforma Docker Desktop (para Windows e macOS) já inclui o Docker Compose. Em sistemas Linux, você precisará instalar o Docker Engine e o Docker Compose separadamente. Também é indicado a utilização de WSL(Ubuntu) caso esteja em um sistema operacional Windows.

## 🛠️ Instalação

Clone o projeto

```bash
 git clone https://github.com/IsabellaSGoncalves/api-pindorama.git
```

Entre no diretório do projeto

```bash
 cd api-pindorama
```

Inicie os contêineres e prepare o banco de dados

```bash
 docker compose up --build -d
 docker compose run --rm web bin/rails db:create db:migrate
```

Acesse a API

*Disponibilizada em http://localhost:3000*

## 👩‍💻 Desenvolvedoras

| Amanda Brito                                                                                                                                                                                                                                                      | Anahi Narieli                                                                                                                                                                                                                                                    | Débora Carvalho                                                                                                                                                                                                                                                       | Isabella Gonçalves                                                                                                                                                                                                                                                      | Julia Bongiovani                                                                                                                                                                                                                                            | Luna Leão                                                                                                                                                                                                                                                     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://avatars.githubusercontent.com/u/160365656?v=4" width="80" height="80" style="border-radius:50%;" /><br>[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Amanda-Brit0) | <img src="https://avatars.githubusercontent.com/u/115493470?v=4" width="80" height="80" style="border-radius:50%;" /><br>[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/AnahiMamani) | <img src="https://avatars2.githubusercontent.com/u/104103793?v=4" width="80" height="80" style="border-radius:50%;" /><br>[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Debora-Carvalho) | <img src="https://avatars.githubusercontent.com/u/161075154?v=4" width="80" height="80" style="border-radius:50%;" /><br>[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/IsabellaSGoncalves) | <img src="https://avatars.githubusercontent.com/u/160390898?v=4" width="80" height="80" style="border-radius:50%;" /><br>[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/BONJIU) | <img src="https://avatars.githubusercontent.com/u/164408694?v=4" width="80" height="80" style="border-radius:50%;" /><br>[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/LunaLeao) |


📅 Última atualização: Set/2025
