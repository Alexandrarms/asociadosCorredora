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