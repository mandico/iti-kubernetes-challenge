# iti Kubernetes Challenge

## Sobre o Desafio: 

Esse é um teste feito para conhecer um pouco mais de cada candidato. Não é um teste objetivo e não há apenas uma solução que consideramos correta. O intuito é ser um estudo de caso com o propósito de conhecer o seu modo de trabalhar.


## Introdução

Temos neste repositório uma aplicação em Kotlin simples com uma API REST que responde um Hello World quando recebe um GET na porta 8080. (ex: curl http://localhost:8080/)

* Containerize essa aplicação
* Crie um Helm chart contendo os manifestos necessários para essa aplicação rodar em um cluster Kubernetes local (use minikube ou kind para fazer o spin-up desse cluster local)
* Utilizando Terraform, realize o deploy da app no cluster.

## Algumas dicas que podem ser importantes:

* Invista tempo em escrever uma documentacão de qualidade
* Empregue quaisquer boas práticas que achar conveniente 
* Organize seu código
* Seja eficiente e simples
* Uso de módulos no terraform será considerado um plus

## Entrega do desafio:

Clone esse repositório e realize todas as modificações, depois que terminar, compacte o repositorio e nos envie. Mantenha o .git no arquivo compactado, queremos analisar os seus commits.

 **Versão do Gradle: 4.10**