#! /usr/bin/python3

import psycopg2
from re import sub
from decimal import Decimal
from config import config
from flask import Flask, render_template, request

# Connect to the PostgreSQL database server
def connect(query):
    conn = None
    print(query)
    try:
        # read connection parameters
        params = config()
 
        # connect to the PostgreSQL server
        print('Connecting to the %s database...' % (params['database']))
        conn = psycopg2.connect(**params)
        print('Connected.')
      
        # create a cursor
        cur = conn.cursor()
        
        # execute a query using fetchall()
        cur.execute(query)
        rows = cur.fetchall()

        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
    # return the query result from fetchall()
    return rows

# app.py
app = Flask(__name__)

# serve form web page
@app.route("/")
def form():
    energy_list=connect("SELECT DISTINCT Energy_type FROM Meter_month_cost_aggragated_by_energy_type order by Energy_type")
    return render_template('my-form.html', energy_list=energy_list)

# handle venue POST and serve result web page
@app.route('/energy-types', methods=['POST'])
def energy_types():
    rows = connect('SELECT * FROM Meter_month_cost_aggragated_by_energy_type WHERE Energy_type = \'' + request.form['energyID'] + '\';')
    heads = ['Energy Type', 'Month', 'Amount', 'Units', 'Monetary Cost', 'Environmental Cost', 'Total Cost']
    return render_template('my-result.html', rows=rows, heads=heads)

@app.route('/date', methods=['POST'])
def date():
    rows = connect('SELECT * FROM Meter_month_cost_aggragated_by_energy_type WHERE Month_name = \'' + request.form['year'] + '-' + request.form['monthName'] + '-01\';')
    heads = ['Energy Type', 'Month', 'Amount', 'Units', 'Monetary Cost', 'Environmental Cost', 'Total Cost']
    return render_template('my-result.html', rows=rows, heads=heads)

@app.route('/graph', methods=['POST'])
def graph():
    xval = connect('SELECT Amount FROM meter_month_cost_aggragated_by_energy_type WHERE Energy_type = \'' + request.form['lineGraph'] + '\' ;')
    yval_monetary = connect('SELECT Total_monetary_cost FROM meter_month_cost_aggragated_by_energy_type WHERE Energy_type = \'' + request.form['lineGraph'] + '\' ;')
    yval_environmental = connect('SELECT Total_environmental_cost FROM meter_month_cost_aggragated_by_energy_type WHERE Energy_type = \'' + request.form['lineGraph'] + '\' ;')
    yval_total = connect('SELECT Total_cost FROM meter_month_cost_aggragated_by_energy_type WHERE Energy_type = \'' + request.form['lineGraph'] + '\' ;')

    xvalues = [float(val[0]) for val in xval]
    yvalues_monetary = [float(Decimal(sub(r'[^\d.]', '', val[0]))) for val in yval_monetary]
    yvalues_environmental = [float(Decimal(sub(r'[^\d.]', '', val[0]))) for val in yval_environmental]
    yvalues_total = [float(Decimal(sub(r'[^\d.]', '', val[0]))) for val in yval_total]
    return render_template("graph.html", xvalues=xvalues, yvalues_monetary=yvalues_monetary, yvalues_environmental=yvalues_environmental, yvalues_total=yvalues_total)

if __name__ == '__main__':
    app.run(debug = True)
