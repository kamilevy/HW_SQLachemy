
from flask import Flask,jsonify
import numpy as np
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from dateutil.parser import _parser

def dater1(*argv):
    res=session.query(Measurement.date).order_by(Measurement.date).all()
    s = int(res[0][0].replace("-",""))
    e = int(res[-1][0].replace("-",""))
    if (len(argv) == 1):
        if(isinstance(int(argv[0].replace("-","")),int)):
          start1= int(argv[0].replace("-",""))
        else:
            return False

        try:
            lazy = parse(argv[0])
            gooddate=True
        except:
            gooddate=False

        if (gooddate):
            if ((start1>=s) and (start1 <= e)):
                return True
            else:
                return False
    elif (len(argv)== 2):

        if(isinstance(int(argv[0].replace("-","")),int)):
          us= int(argv[0].replace("-",""))
        else:
            return False
        if(isinstance(int(argv[1].replace("-","")),int)):
          ue= int(argv[1].replace("-",""))
        else:
            return False

        try:
            lazy2 = parse(argv[0])
            gooddate1=True
        except:
            gooddate1=False
        
        try: 
            lazy1 = parse(argv[1])
            gooddate2=True
        except:
            gooddate2=False
        if (gooddate1 and gooddate2):
            if (((us>=s) and (us <= e)) and ((ue>=s) and (ue <= e))):
                if (ue>us):
                    return True
                else:
                    return False
    else:
        return False

        

 
   

engine = create_engine("sqlite:///hawaii.sqlite",connect_args={'check_same_thread':False})
Base = automap_base()
Base.prepare(engine, reflect=True)

#build table classes

Measurement = Base.classes.measurement
Station = Base.classes.station

#initiate db session

session = Session(engine,autoflush=True)

app = Flask(__name__)

@app.route("/")
def index():
    return( 
        f"Available Routes</br>"
        f"/api/v1.0/precipitation</br>"
        f"/api/v1.0/stations</br>"
        f"/api/v1.0/tobs</br>"
        f"/api/v1.0/&ltstart&gt</br>"
        f"/api/v1.0/&ltstart&gt/&ltend&gt</br>"
    )

@app.route("/api/v1.0/precipitation")
def precip():
    res=session.query(Measurement.date, Measurement.prcp).order_by(Measurement.date).all()
    pre=[]
    for i in res:
        date1 = {i[0]:i[1]}
        pre.append(date1)
    return jsonify(pre)

@app.route("/api/v1.0/stations")
def stats():
    res=session.query(Station.station, Station.name).all()
    pre=[]
    for i in res:
        stats = {i[0]:i[1]}
        pre.append(stats)
    return jsonify(pre)

@app.route("/api/v1.0/tobs")
def tempobs():
    sess1=session.query(Measurement.date).order_by(Measurement.date).all()
    dt1=sess1[-1][0]
    datesplit=dt1.split("-")
    j=str(int(datesplit[0]) -1)
    enddate=(j + "-"+ datesplit[1] +"-"+datesplit[2])
    
    
    sess2=session.query(Measurement.tobs, Measurement.date).filter (Measurement.date>=enddate).filter(Measurement.date <=dt1).all()
    temps=[]
    for i in sess2:
        dat = {i[0]:i[1]}
        temps.append(dat)
    return jsonify(temps)

@app.route ('/api/v1.0/<start>')
def one(start):

    sel = [func.min(Measurement.tobs),func.avg(Measurement.tobs),func.max(Measurement.tobs)]
    res = session.query(*sel).filter(Measurement.date >= start).all()
    ls1 = list(res[0]),
    dat= {'min_temp':ls1[0],
              'avg_temp':ls1[1],
              'max_temp':ls1[2]}
    return jsonify(dat)
    


if __name__ == "__main__":
    app.run(debug=True)