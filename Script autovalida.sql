SET SERVEROUTPUT ON
ALTER SESSION SET CURRENT_SCHEMA = FOZ_SAN;
/
DECLARE
  pre_valid        INTEGER := 0;
  max_datetime     DATE    := to_date('01/01/2022 01:00','DD/MM/YYYY HH24:MI:SS');
  s_sql            VARCHAR(5000);
  row_count_backup INTEGER := 0;
  row_count_update INTEGER := 0;
  row_count_update_total INTEGER := 0;  
  
BEGIN
  SELECT
    CASE
      WHEN sysdate < max_datetime
      THEN 1
      ELSE 0
    END
  INTO pre_valid
  FROM dual;
  
  IF pre_valid = 0 THEN
    Raise_Application_Error(-20001, 'Execução inválida, data/hora maxima '||TO_CHAR(max_datetime,'DD/MM/YYYY HH:MI:SS'));
  END IF;
  
  dbms_output.put_line('Pré validação OK');
  
  s_sql := 'CREATE TABLE BKP ';
  dbms_output.put_line('Criando Backup');
  
  EXECUTE IMMEDIATE s_sql;
  s_sql := 'SELECT count(xx) reg FROM XXXXXXXXXX';
  EXECUTE IMMEDIATE s_sql INTO row_count_backup ;
  
  IF row_count_backup = 0 THEN
    Raise_Application_Error(-20002, 'Backup falhou, nenhum registro encontrado');
  END IF;
  
  dbms_output.put_line('Backup OK');
  
  s_sql := 'update XXXXXXXXXXXXXXXXX';
  EXECUTE immediate 'begin ' || s_sql ||'; :x
 := sql%rowcount; end;' USING OUT row_count_update;
  dbms_output.put_line('Updated ' || row_count_update || ' rows');
  row_count_update_total := row_count_update_total + row_count_update;

  
    dbms_output.put_line('>>>>>> ' || row_count_backup || ' rows' || row_count_update_total);

  IF row_count_backup <> row_count_update_total THEN
    Raise_Application_Error(-20003, 'Alteração falhou, a quantidade de registro afetado é diferente do backup');
  END IF;
  
  dbms_output.put_line('Atualização OK');
  COMMIT;
  
  dbms_output.put_line('Executado com sucesso');
  
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  DBMS_OUTPUT.put_line (SQLERRM);
END;
/

