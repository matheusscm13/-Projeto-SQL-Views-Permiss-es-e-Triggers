show databases;

use company_constraints;


-- Número de empregados por departamento e localidade
CREATE VIEW vw_empregados_departamento_localidade AS
SELECT d.dname, dl.dlocation, COUNT(e.ssn) AS total_funcionarios
FROM departament d
JOIN employee e ON d.dnumber = e.dno
JOIN dept_locations dl ON d.dnumber = dl.dnumber
GROUP BY d.dname, dl.dlocation;

-- Lista de departamentos e seus gerentes
CREATE VIEW vw_departamentos_gerentes AS
SELECT d.dname, e.fname, e.lname
FROM departament d
JOIN employee e ON d.mgr_ssn = e.ssn;

-- Projetos com maior número de empregados
CREATE VIEW vw_projetos_empregados AS
SELECT p.pname, COUNT(w.essn) AS total_empregados
FROM project p
JOIN works_on w ON p.pnumber = w.pno
GROUP BY p.pname
ORDER BY total_empregados DESC;

-- Lista de projetos, departamentos e gerentes
CREATE VIEW vw_projetos_departamentos_gerentes AS
SELECT p.pname, d.dname, e.fname, e.lname
FROM project p
JOIN departament d ON p.dnum = d.dnumber
JOIN employee e ON d.mgr_ssn = e.ssn;

-- Empregados com dependentes e se são gerentes
CREATE VIEW vw_empregados_dependentes_gerentes AS
SELECT e.fname, e.lname, 
       CASE WHEN d.essn IS NOT NULL THEN 'Possui dependente' ELSE 'Sem dependente' END AS dependente,
       CASE WHEN e.ssn IN (SELECT mgr_ssn FROM departament) THEN 'Gerente' ELSE 'Não gerente' END AS cargo
FROM employee e
LEFT JOIN dependent d ON e.ssn = d.essn;



-- Criar usuário gerente
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'senha123';
GRANT SELECT ON company_constraints.employee TO 'gerente'@'localhost';
GRANT SELECT ON company_constraints.departament TO 'gerente'@'localhost';
GRANT SELECT ON company_constraints.vw_departamentos_gerentes TO 'gerente'@'localhost';

-- Criar usuário empregado
CREATE USER 'empregado'@'localhost' IDENTIFIED BY 'senha123';
GRANT SELECT ON company_constraints.employee TO 'empregado'@'localhost';
-- Não conceder acesso às views de departamentos ou gerentes


-- Trigger de remoção: antes de deletar usuário, salvar em backup
CREATE TABLE user_backup (
    ssn CHAR(9),
    fname VARCHAR(50),
    lname VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER trg_user_before_delete
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_backup (ssn, fname, lname)
    VALUES (OLD.ssn, OLD.fname, OLD.lname);
END$$
DELIMITER ;

-- Trigger de atualização: antes de atualizar salário
DELIMITER $$
CREATE TRIGGER trg_employee_before_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SET NEW.salary = OLD.salary; -- impede redução
    END IF;
END$$
DELIMITER ;


