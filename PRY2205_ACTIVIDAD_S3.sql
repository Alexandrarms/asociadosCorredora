PROMPT ==== CASO 1: LISTADO DE CLIENTES CON RANGO DE RENTA ====

ACCEPT renta_minima NUMBER PROMPT 'Ingrese la RENTA MÍNIMA: '
ACCEPT renta_maxima NUMBER PROMPT 'Ingrese la RENTA MÁXIMA: '

SELECT 
       LPAD(TO_CHAR(numrut_cli, '99G999G999'), 10, ' ') || '-' || dvrut_cli        AS "RUT_CLIENTE",
       INITCAP(nombre_cli) || ' ' || INITCAP(appaterno_cli) || ' ' || INITCAP(apmaterno_cli)
                                                                                   AS "NOMBRE_COMPLETO_CLIENTE",
       INITCAP(direccion_cli)                                                       AS "DIRECCION_CLIENTE",
       '$' || TO_CHAR(renta_cli, '999G999')                                         AS "RENTA_CLIENTE",
       celular_cli                                                                  AS "CELULAR_CLIENTE",
       CASE
           WHEN renta_cli > 500000 THEN 'TRAMO 1'
           WHEN renta_cli BETWEEN 400000 AND 500000 THEN 'TRAMO 2'
           WHEN renta_cli BETWEEN 200000 AND 399999 THEN 'TRAMO 3'
           ELSE 'TRAMO 4'
       END                                                                          AS "TRAMO_RENTA_CLIENTE"
FROM   cliente
WHERE  renta_cli BETWEEN &renta_minima AND &renta_maxima
  AND  celular_cli IS NOT NULL
ORDER  BY "NOMBRE_COMPLETO_CLIENTE";



PROMPT ==== CASO 2: SUELDO PROMEDIO POR CATEGORÍA DE EMPLEADO ====

ACCEPT sueldo_promedio_minimo NUMBER PROMPT 'Ingrese el SUELDO PROMEDIO MÍNIMO: '

SELECT 
       e.id_categoria_emp                                           AS "CODIGO_CATEGORIA",
       c.desc_categoria_emp                                         AS "DESCRIPCION_CATEGORIA",
       COUNT(e.numrut_emp)                                          AS "CANTIDAD_EMPLEADOS",
       s.desc_sucursal                                              AS "SUCURSAL",
       '$' || TO_CHAR(ROUND(AVG(NVL(e.sueldo_emp, 0))), '999G999G999')
                                                                    AS "SUELDO_PROMEDIO"
FROM   empleado e
JOIN   categoria_empleado c ON e.id_categoria_emp = c.id_categoria_emp
JOIN   sucursal s           ON e.id_sucursal      = s.id_sucursal
GROUP  BY e.id_categoria_emp, c.desc_categoria_emp, s.desc_sucursal
HAVING AVG(NVL(e.sueldo_emp, 0)) > &sueldo_promedio_minimo
ORDER  BY AVG(NVL(e.sueldo_emp, 0)) DESC;



PROMPT ==== CASO 3: ARRIENDO PROMEDIO POR TIPO DE PROPIEDAD ====

SELECT 
       t.id_tipo_propiedad                                   AS "CODIGO_TIPO",
       t.desc_tipo_propiedad                                 AS "DESCRIPCION_TIPO",
       COUNT(p.nro_propiedad)                                AS "TOTAL_PROPIEDADES",
       '$' || TO_CHAR(ROUND(AVG(p.valor_arriendo)), '999G999G999')  
                                                            AS "PROMEDIO_ARRIENDO",
       TO_CHAR(ROUND(AVG(p.superficie)), '999G999')          AS "PROMEDIO_SUPERFICIE",
       '$' || TO_CHAR(ROUND(AVG(p.valor_arriendo / p.superficie)), '999G999')  
                                                            AS "VALOR_ARRIENDO_M2",
       CASE
           WHEN AVG(p.valor_arriendo / p.superficie) < 5000 THEN 'ECONÓMICO'
           WHEN AVG(p.valor_arriendo / p.superficie) BETWEEN 5000 AND 10000 THEN 'MEDIO'
           ELSE 'ALTO'
       END                                                   AS "CLASIFICACION"
FROM   propiedad p
JOIN   tipo_propiedad t ON p.id_tipo_propiedad = t.id_tipo_propiedad
GROUP  BY t.id_tipo_propiedad, t.desc_tipo_propiedad
HAVING AVG(p.valor_arriendo / p.superficie) > 1000
ORDER  BY AVG(p.valor_arriendo / p.superficie) DESC;


-- FIN DEL SCRIPT.