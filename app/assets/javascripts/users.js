google.load('visualization', '1.0', {'packages':['corechart']});
// Set a callback to run when the Google Visualization API is loaded.

google.setOnLoadCallback(drawCharts);

function drawCharts(){
  drawPieChart();
  drawPieChart2();
}

// Callback that creates and populates a data table, 
// instantiates the pie chart, passes in the data and
// draws it.
function drawPieChart() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string', 'Topping');
data.addColumn('number', 'Slices');
data.addRows([
  ['Mushrooms', 3],
  ['Onions', 1],
  ['Olives', 1], 
  ['Zucchini', 1],
  ['Pepperoni', 2]
]);

// Set chart options
var options = {'title':'How Much Pizza I Ate Last Night',
               'width':400,
               'height':300};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
chart.draw(data, options);
}

// Callback that creates and populates a data table, 
// instantiates the pie chart, passes in the data and
// draws it.
function drawPieChart2() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string', 'Topping');
data.addColumn('number', 'Slices');
data.addRows([
  ['Mushrooms', 3],
  ['Onions', 1],
  ['Olives', 1], 
  ['Zucchini', 1],
  ['Pepperoni', 2]
]);

// Set chart options
var options = {'title':'How Much Pizza I Ate Last Night',
               'width':400,
               'height':300,
                'is3D': true,
                'legend.position': 'left'};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_div2'));
chart.draw(data, options);
}