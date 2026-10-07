# Projeto SQL – Views, Permissões e Triggers

## 📌 Descrição
Este projeto foi desenvolvido como parte de um desafio de Banco de Dados.  
O objetivo é criar **views personalizadas com permissões de acesso** e **triggers para cenários de e-commerce**, aplicados em bases de dados MySQL.

---

## 🚀 Parte 1 – Views e Permissões
- Views criadas para:
  - Número de empregados por departamento e localidade
  - Lista de departamentos e seus gerentes
  - Projetos com maior número de empregados
  - Lista de projetos, departamentos e gerentes
  - Empregados com dependentes e se são gerentes

- Permissões:
  - Usuário **gerente** → acesso a `employee`, `departament` e views relacionadas a gerentes.
  - Usuário **empregado** → acesso apenas a `employee`.

---

## ⚙️ Parte 2 – Triggers
- **Remoção (BEFORE DELETE)**: salva dados de usuários em tabela de backup antes da exclusão.  
- **Atualização (BEFORE UPDATE)**: garante integridade ao atualizar salários, impedindo reduções indevidas.  

---

## 📂 Estrutura do repositório
┣ 📜 views.sql
┣ 📜 permissions.sql
┣ 📜 triggers.sql
┣ 📜 README.md


---

## ✅ Conclusão
Este projeto demonstra como:
- Criar views para personalizar acessos e restringir informações.  
- Definir permissões de usuários em nível de view.  
- Utilizar triggers para manter integridade e histórico de dados em cenários de e-commerce.  
