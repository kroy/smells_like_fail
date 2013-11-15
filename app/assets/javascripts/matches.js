$(function(){
	$('#gpm-chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'GPM Breakdown By Player'
            },
            xAxis: {
                categories: gon.players
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Total GPM'
                }
            },
            legend: {
                backgroundColor: '#FFFFFF',
                reversed: false
            },
            plotOptions: {
                series: {
                    stacking: 'normal'
                }
            },
                series: [{
                name: 'Neutrals',
                data: gon.neut_gold
            }, {
                name: 'Hero Kills',
                data: gon.hero_kill_gold
            }, {
                name: 'Creeps/Buildings',
                data: gon.creep_building_gold
            }]
    });

    $('#damage-chart').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'Hero Damage by Player'
        },
        tooltip: {
    	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Damage Done',
            data: gon.hero_damage_done
        }]
    });
});