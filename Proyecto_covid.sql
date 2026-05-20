--Julio 2022, Raquel Tello
--Proyecto 1 Portafolio
--Objetivo: Explorar y visualizar información de covid
--1. Verifique la conexión con las tablas
SELECCIONAR * DEmuertes por COVID-19;
SELECCIONAR * DEvacunas contra el covid;
--2. Explorar las columnas a utilizar / Explore columnas a utilizar.
SELECCIONARubicación,
  casos_totales,
  STR_TO_DATE(fecha,'%c/%d/%y')COMO fecha,
  casos_totales,
  nuevos_casos,
  muertes_totales,
  población
DE  muertes por COVID-19
DÓNDEcontinenteNO ES NULO
ORDENAR POR 1,2;
--3. Explorar la probabilidad de morir en caso de contagio en Chile/ Explorar la probabilidad de morir si contraes covid en Chile
SELECCIONARubicación,
  STR_TO_DATE(fecha,'%c/%d/%y')COMO fecha,
  casos_totales,
  muertes_totales,
  (total_muertes/casos_totales)*100 comoPorcentaje de mortalidad
DE  muertes por COVID-19
DÓNDEubicaciónCOMO '%Chile%'
    YcontinenteNO ES NULO
ORDENAR POR 1,2;
--Casos Totales vs Población / Mirando el Total de Casos vs Población
--Porcentaje de la población que muestra qué porcentaje de la población contrajo covid
SELECCIONARubicación,
  STR_TO_DATE(fecha,'%c/%d/%y')COMO fecha,
  población,
  casos_totales,
  (casos_totales/población)*100 comoPorcentaje_de_Población_Infectada
DE  muertes por COVID-19
DÓNDEubicaciónCOMO '%Chile%'
    YcontinenteNO ES NULO
ORDENAR POR 1,2
;
--Países con la mayor taza de contagio / Los países que buscan tienen la tasa de infección más alta en comparación con la población
SELECCIONARubicación,
  población,
  MÁXIMO(casos_totales)COMOMayor número de infecciones,
  MÁXIMO((casos_totales/población)*100)comoPorcentaje_de_Población_Infectada
DE  muertes por COVID-19
DÓNDE  continenteNO ES NULO
AGRUPACIÓN PORubicación,
		 población
ORDENAR PORPorcentaje_de_Población_InfectadaDESC;
--Paises con el mayor cantidad de muertes por poblacion // Mostrando países con el mayor recuento de muertes por población
SELECCIONAR
  ubicación,
  MÁXIMO(CAST(total_muertes)COMOFIRMADO))COMONúmero total de muertes
DE  muertes por COVID-19
DÓNDE  continenteNO ES NULO
  Yubicación NOEN('América del norte','unión Europea','Sudamerica')
AGRUPACIÓN PORubicación
ORDENAR PORNúmero total de muertesDESC;
--Continente con el mayor cantidad de muertes por poblacion // Mostrando el continente con el mayor recuento de muertes por población
SELECCIONAR
  continente,
  MÁXIMO(CAST(total_muertes)COMOFIRMADO))COMONúmero total de muertes
DE  muertes por COVID-19
DÓNDE  continenteNO ES NULO
 --Y continente que NO ESTÉ EN ('América del Norte', 'Unión Europea', 'América del Sur')
AGRUPACIÓN PORcontinente
ORDENAR PORNúmero total de muertesDESC;
--Cantidad de contagios acumulados diarios en el mundo
SELECCIONAR
      STR_TO_DATE(fecha,'%c/%d/%y')COMO fecha,
      SUMA(casos_nuevos)COMOcasos_globales,
      SUMA(nuevas muertes)COMOmuertes_globales,
      REDONDO(SUMA(nuevas muertes)/SUMA(casos_nuevos)* 100,2)COMOtasa global
DEmuertes por COVID-19
DÓNDEcontinenteNO ES NULO
AGRUPACIÓN POR fecha
ORDENAR POR 1,2;
--Población total vs vacunas / Total Population vs Vaccination
SELECCIONAR
  DEA.continente,
  DEA.ubicación,
  STR_TO_DATE(DEA.fecha,'%c/%d/%y')COMO fecha,
  DEA.población,
  vacaciones.nuevas_vacunas
DEmuertes por covid dea
UNIRSEvacunas contra el covid
    EN DEA.ubicación = vacaciones.ubicación
    Y DEA.fecha = vacaciones.fecha
DÓNDE DEA.continente NO ES NULO
ORDENAR POR 2,3;
--- Recuento de vacunas acumuladas diarias por ubicación/
SELECCIONAR
  DEA.continente,
  DEA.ubicación,
  STR_TO_DATE(DEA.fecha,'%c/%d/%y')COMO fecha,
  DEA.población,
  vacaciones.nuevas_vacunas,
  SUMA(ELENCO(vacaciones.nuevas_vacunas COMOFIRMADO)) SOBRE (PARTICIÓN PORDEA.ubicación ORDENAR POR DEA.ubicación,DEA.fecha)comopersonas_vacunadas_en_rolling
DEmuertes por covid dea
UNIRSEvacunas contra el covid
    EN DEA.ubicación = vacaciones.ubicación
    Y DEA.fecha = vacaciones.fecha
DÓNDE DEA.continente NO ES NULO
ORDENAR POR 2,3;
--usar una CTE para realizar cálculos adicionales sobre la última consulta
CON PeovsVac (continente, ubicación,fecha, población , nuevas_vacunaciones, personas_vacunadas_actualizadas)
COMO(SELECCIONAR
      DEA.continente,
      DEA.ubicación,
      STR_TO_DATE(DEA.fecha,'%c/%d/%y')COMO fecha,
      DEA.población,
      vacaciones.nuevas_vacunas,
      SUMA(ELENCO(vacaciones.nuevas_vacunas COMOFIRMADO)) SOBRE (PARTICIÓN PORDEA.ubicación ORDENAR POR DEA.ubicación,DEA.fecha)comopersonas_vacunadas_en_rolling
    DEmuertes por covid dea
    UNIRSEvacunas contra el covid
        EN DEA.ubicación = vacaciones.ubicación
        Y DEA.fecha = vacaciones.fecha
    DÓNDE DEA.continente NO ES NULO
    ORDENAR POR 2,3)
SELECCIONAR *,
       (personas_en_rolling_vacunadas/población)*100 COMOtaza_vacunación_población
DEPeovsVac;
CON PeovsVac--(continente, ubicación, fecha, población, nuevas_vacunas, personas_vacunadas) #puedo usar algunas de las columnas de a
COMO(SELECCIONAR
      DEA.continente,
      DEA.ubicación,
      STR_TO_DATE(DEA.fecha,'%c/%d/%y')COMO fecha,
      DEA.población,
      vacaciones.nuevas_vacunas,
      SUMA(ELENCO(vacaciones.nuevas_vacunas COMOFIRMADO)) SOBRE (PARTICIÓN PORDEA.ubicación ORDENAR POR DEA.ubicación,DEA.fecha)comopersonas_vacunadas_en_rolling
    DEmuertes por covid dea
    UNIRSEvacunas contra el covid
        EN DEA.ubicación = vacaciones.ubicación
        Y DEA.fecha = vacaciones.fecha
    DÓNDE DEA.continente NO ES NULO
    ORDENAR POR 2,3)
SELECCIONAR *,
       (personas_en_rolling_vacunadas/población)*100 COMOtaza_vacunación_población
DEPeovsVac;
--TABLA DE TEMPERATURAS
GOTA MESASI EXISTE _PorcentajeDePoblaciónVacunada
CREAR MESA Porcentaje de población vacunada
(
Continente nvarchar(255),
Ubicación nvarchar(255),
Fechafecha y hora,
Poblaciónnumérico,
Nuevas vacunasnumérico,
RollingPeopleVaccinatednumérico
)
INSERTAR ENPorcentaje de población vacunada
SELECCIONAR DEA.continente,
      DEA.ubicación,
      STR_TO_DATE(DEA.fecha,'%c/%d/%y')COMO fecha,
      DEA.población,
      vacaciones.nuevas_vacunas,
      SUMA(ELENCO(vacaciones.nuevas_vacunas COMOFIRMADO)) SOBRE (PARTICIÓN PORDEA.ubicación ORDENAR POR DEA.ubicación,DEA.fecha)comoRollingPeopleVaccinated
    DEmuertes por covid dea
    UNIRSEvacunas contra el covid
        EN DEA.ubicación = vacaciones.ubicación
        Y DEA.fecha = vacaciones.fecha
   --  DONDE dea.continent NO ES NULO
SELECCIONAR *, (RollingPeopleVaccinated/Población)*100
DEPorcentaje de población vacunada
--Crea una vista para almacenar datos para visualizaciones posteriores.
CREAR VISTA Porcentaje de población vacunada COMO
SELECCIONAR DEA.continente,
      DEA.ubicación,
      STR_TO_DATE(DEA.fecha,'%c/%d/%y')COMO fecha,
      DEA.población,
      vacaciones.nuevas_vacunas,
      SUMA(ELENCO(vacaciones.nuevas_vacunas COMOFIRMADO)) SOBRE (PARTICIÓN PORDEA.ubicación ORDENAR POR DEA.ubicación,DEA.fecha)comoRollingPeopleVaccinated
    DEmuertes por covid dea
    UNIRSEvacunas contra el covid
        EN DEA.ubicación = vacaciones.ubicación
        Y DEA.fecha = vacaciones.fecha
    DÓNDE DEA.continente NO ES NULO