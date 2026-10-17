# 1. O Conceito Geral: Shift Left Security

O que aprendemos: A segurança tradicional costuma acontecer no final do projeto (como uma auditoria antes de lançar o produto). O Shift Left ("mover para a esquerda") consiste em antecipar a segurança para o início do desenvolvimento, automatizando verificações diretamente nas ferramentas do dia a dia (como Git e GitHub Actions).

# 2. A Estrutura da Pipeline Automatizada (GitHub Actions)

Montamos uma esteira que é disparada automaticamente a cada Pull Request ou Push, dividida em 4 camadas de defesa em profundidade:

## Stage 1 — Secret Scanning (Gitleaks):

Varre o histórico e os arquivos para impedir que chaves de API, senhas ou tokens privados sejam enviados acidentalmente para o repositório.

## Stage 2 — SAST / Análise Estática de Código (Semgrep):

Analisa o código-fonte (app.js) procurando por padrões inseguros ou vulnerabilidades lógicas antes de rodar a aplicação.

## Stage 3 — SCA / Análise de Dependências e Containers (Trivy):

Inspeciona as bibliotecas de terceiros (package.json) contra bases públicas de CVEs (vulnerabilidades conhecidas) e analisa a segurança do container.

## Stage 4 — IaC Security / Infraestrutura como Código (Checkov):

Valida os arquivos de configuração de infraestrutura (Terraform) para garantir que recursos em nuvem (como discos e servidores) sigam as melhores práticas de conformidade e segurança (ex: exigir criptografia).

# 3. Conceitos Avançados Aplicados

Padronização SARIF: Aprendemos a usar o formato unificado SARIF para consolidar os relatórios de diferentes ferramentas de segurança diretamente na aba Security -> Code scanning alerts do GitHub.

Container Hardening & Princípio do Menor Privilégio:

Víamos que o Docker roda aplicações como root por padrão.

Aprendemos a criar um usuário dedicado (appuser) e usar imagens minimalistas (Alpine). Isso garante que, caso a aplicação seja comprometida, o invasor fique confinado e não ganhe privilégios administrativos para escapar do container ou invadir o servidor host.

Infrastructure as Code (IaC) com Terraform:

Entendemos como gerenciar infraestrutura corporativa por meio de arquivos de texto versionados no Git, permitindo que a segurança da nuvem seja auditada de forma automatizada por Policy as Code antes mesmo de ser provisionada.