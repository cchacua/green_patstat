# Jupyter distribution with Postgres

FROM jupyter/scipy-notebook:latest

USER root
RUN apt-get update && apt-get install -y libpq-dev

USER $NB_UID
RUN pip install psycopg2
RUN conda install -c conda-forge gdal
RUN pip install pandasql geopandas pycountry mapclassify
RUN pip install pyarrow  
RUN pip install plotly dash

