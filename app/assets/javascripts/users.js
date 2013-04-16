// $(document).ready(function () {
//     $("img").click(function() {
//         $("#behe").hide("slow")
//     });
// });

$(function () {
        $('#progression').highcharts({
            chart: {
                type: 'line',
                marginRight: 130,
                marginBottom: 25
            },
            title: {
                text: 'GPM Progression',
                x: -20 //center
            },
            // subtitle: {
            //     text: 'Source: WorldClimate.com',
            //     x: -20
            // },
            xAxis: {
                categories: gon.match_numbers
            },
            yAxis: {
                title: {
                    text: 'GPM'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }],
                min: 0,
                max: 800
            },
            // tooltip: {
            //     valueSuffix: '°C'
            // },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -10,
                y: 100,
                borderWidth: 0
            },
            series: [{
                name: 'GPM',
                data: gon.gpms
            },
            {
                name: 'APM',
                data: gon.apms
            }
            // , {
            //     name: 'New York',
            //     data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
            // }, {
            //     name: 'Berlin',
            //     data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
            // }, {
            //     name: 'London',
            //     data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
            // }
            ]
        });
    });

$(function () {
        $('#user_chart_gold').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Breakdown of Average Gold Earned'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage}%</b>',
                percentageDecimals: 1,
                //valueDecimals: 2
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    showInLegend: true,
                    dataLabels: {
                        enabled: false
                        // color: '#000000',
                        // connectorColor: '#000000',
                        // formatter: function() {
                        //     return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
                        // }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'Avg Gold Breakdown',
                data: [
                    ['Creep Kills',   gon.gold[0]],
                    ['Neutral Kills',       gon.gold[1]],
                    ['Hero Kills',    gon.gold[2]]
                ]
            }]
        });
    });