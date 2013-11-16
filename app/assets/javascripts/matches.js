$(function(){
	$('#gpm-chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'GPM Breakdown By Player'
            },
            xAxis: {
                categories: gon.players,
                labels: {
                	rotation: 20,
                	align: "left"
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Total GPM'
                }
            },
            tooltip:{
            	valueSuffix: " gpm"
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
            	name: 'Lost to Death',
            	data: gon.gold_lost_death,
            	color: "#CC0000"
            	}, {
                name: 'Neutrals',
                data: gon.neut_gold,
                color: "#FFA319"
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
                },
                colors: [
                	"#214AFF",
                	"#00FFCC",
                	"#6600FF",
                	"#FFFF00",
                	"#FF9900",
                	"#E68AE6",
                	"#747476",
                	"#558FFA",
                	"#26754B",
                	"#523721"
                ]
            }
        },
        series: [{
            type: 'pie',
            name: 'Damage Done',
            data: gon.hero_damage_done
        }]
    });
});