<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
    <link href="./css/bootstrap-5.2.3/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
	 <link href="font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="./css/style.css"></link>
    <script src="./js/d3.v5.min.js"></script>
    <script src="./js/jquery-latest.min.js"></script>
	 <script src="./js/FileSaver.min.js"></script>
	 <title>D3js Force Directed Graph</title>
</head>
<body>

<div id="outer-form" >
	<div style="display:flex;align-items:center;">
		<div class="upload-container">
			<form id="form" enctype="multipart/form-data" class="form-control-sm" >
				<span style="font-size:1.1em;font-weight: bold;">Upload csv file : </span>&nbsp;
				<input name="file" id="file" class="btn btn-outline-secondary" type="file" accept=".csv" multiple="false" />&nbsp;
			</form>
		</div>
		<div>
			<button id="btnUpload" class="btn btn-primary upload-btn">
				<i class="fa fa-upload" aria-hidden="true"></i>
				<span>Load</span>
			</button>
		</div>
		<div style="padding:5px;">		
			<button id="btnExport" class="btn btn-secondary">
				<i class="fa fa-download" aria-hidden="true"></i>
				<span>Export as SVG</span>
			</button>
		</div>
		<div style="padding:5px;">
			<input id="identifier" class="btn btn-outline-secondary" type="text" value=""/>
		</div>
		<div style="padding:5px;">		
			<button id="btnLocate" class="btn btn-secondary" onclick="zoomInNode($('#identifier').val());">
				<i class="fa fa-paper-plane-o" aria-hidden="true"></i>
				<span>Locate</span>
			</button>
		</div>
	</div>
</div>

<div id="chart" style="margin-top:5px">
	<main>
		<input id="tabGraph" type="radio" name="tabs" checked />
		<label for="tabGraph" >Graph</label>
		<input id="tabTable" type="radio" name="tabs" />
		<label for="tabTable">Table</label>
				

	<section id="sectionGraph">
		<svg id="svg"></svg>
	</section>
	<section id="sectionTable">
		<div id="json2table" class="container mt-5" style="display:block;background-color: seashell;border-radius: 15px;">
		<table class="table table-hover">
			<thead>
				<tr>
				<th>Source</th>
				<th>Name</th>
				<th>Target</th>
				<th>Name</th>
				<th>Link</th>
				</tr>
			</thead>
			<tbody id="tbody-id">			
			</tbody>
		</table>
		</div>			
	</section>
	</main>
	<div id="legend" style="border-radius: 10px;"></div>
</div>

<div id="tooltip" style="display:none;"></div>
<div id="summary" style="display:none;"></div>

<script type="text/javascript">

$(document).ready(function() {
    $('#btnUpload').on('click', function () {
		resetSvg();
        upload();
    });
});


// Locate and Zoom to Node
function zoomInNode(searchId){
	if(searchId == undefined){ return null;}
	
	let zoom = d3.zoom()
	// Extra caution (really necessary ?)
	.on('zoom', function(){
		zoom.filter(() => {
			if (d3.event.type === 'wheel') {
			// don't allow zooming without pressing [ctrl] key
			return d3.event.ctrlKey;
			}			
			return true;
		})
		// ensure "g" within "svg" dispatch events
		let g = d3.select('#svg g');
		g.attr("transform", d3.event.transform)
		g.attr("translate", d3.event.translate)
		g.attr("scale", d3.event.scale)
		g.on("dblclick.zoom", null)
		;
		// disallow dblclick.zoom and click.zoom in svg
		let svg = d3.select('#svg')
		.on("dblclick.zoom", null)
		.on("click.zoom", null)
		;		
	})
	;
	// switch to tabGraph
	let tab = document.getElementById('tabGraph');
	tab.checked = true;	
	let svg = d3.select('#svg');
	// locate and zoom to Node
	let result=[]=d3.selectAll(".node")
		.data()
		.filter(function(d) { 
			return d.id == searchId;
		});
	
	console.log(searchId + " : " + result[0].label);

	if (result !== undefined) {
		d3.select('#svg').call(zoom);
		svg.transition().duration(2000).call(
			zoom.transform,
			d3.zoomIdentity.translate(window.innerWidth/2, window.innerHeight/2).scale(1.25).translate(-result[0].x, -result[0].y)			
		);
		let RADIUS = 38;
		d3.selectAll(".node").filter((d) => d.id==searchId).select("circle").transition()
			.duration(2500)
			.attr("r", RADIUS*1.5)
			.transition()
			.duration(750)
			.attr("r", RADIUS)
		;
	};

	svg.dispatch('click');

	return 0;
}

function upload(){
    $.ajax({
        url:"rest/upload/csv",
        type:"POST",
        data:new FormData($('#form')[0]),
        processData:false,
        contentType:false,
        success:function(response){
            let data = [];
            Array.from(response.split("\n")).forEach(function(row,i){
	            let cols = row.split(",")
	            if(cols[0] != "source" && cols[0] != "") { // skip headers and lines with no source
		            data.push({
		                source:cols[0]
		                ,sourceLabel:cols[1] != "" ? cols[1].normalize('NFD').replace(/[\u0300-\u036f]/g, "") : ""
		                ,target:cols[2]
		                ,targetLabel:cols[3] != "" ? cols[3].normalize('NFD').replace(/[\u0300-\u036f]/g, "") : ""
		                ,linkLabel:cols[4] != "" ? cols[4].normalize('NFD').replace(/[\u0300-\u036f]/g, "") : ""
		            });
	            }
            })            
            // console.log("csv : " + data);
            d3.select("#chart svg").selectAll('*').remove();
			populateTable("#tbody-id",data);
            chart(data);
        }
    });
}

function populateTable(tbody,data){
	if(typeof(data[0]) === 'undefined'){ return null;}

	$.each(data, function(index, row ) {
		let tr = '<tr>';
		$.each(row, function(index, colData ) {
			if(index=='source' || index=='target'){
				tr += '<td style="cursor:pointer" onclick="zoomInNode(' + colData + ')">';
				tr += '<span style="color:steelblue;">' + colData + '</span>';
				tr += '</td>';
			}else{
				tr +='<td>';
				tr += colData;
				tr +='</td>'
			}
		});
		tr += '</tr>';
		$(tbody).append(tr);
	})
}

function chart(groupMembers){

	if(groupMembers.length < 1 ){
		d3.select("#chart").html("<span style='font-weight:bold; color:red;'>No data</span>");
	}

	let nodes = [];
	let links = [];

	// Populate nodes and links (remove duplicates)
	Array.from(groupMembers).forEach(function (d){
		
		if (nodes.findIndex(function(item){ return item.id === d.source; }) < 0) {
			nodes.push({id:d.source, label:d.sourceLabel});
		}
		if (nodes.findIndex(function(item){ return item.id === d.target; }) < 0) {
			nodes.push({id:d.target, label:d.targetLabel});
		}
		if (links.findIndex(function(item){ return item.source === d.source && item.target === d.target && item.linkLabel===d.linkLabel}) < 0) {
			links.push({source:d.source, target:d.target, sourceLabel:d.sourceLabel, targetLabel:d.targetLabel, linkLabel:d.linkLabel});
		}
	});

	console.log("Nodes : "+nodes.length);
	console.log("Links : "+links.length);

	d3.select("#legend").html("<u>Infos :</u><br/>Nodes : <b>"+nodes.length+"</b><br/>Links : <b>"+links.length+"</b>");

	let colors = d3.scaleOrdinal(d3.schemeSet3);
	let width = window.innerWidth;
	let height = window.innerHeight; 
	const RADIUS = 38;

	let svg = d3.select("#chart svg")
		.attr("width",width)
		.attr("height",height)
		// Pan & Zoom 
		.call(d3.zoom() //cf : https://coderwall.com/p/psogia/simplest-way-to-add-zoom-pan-on-d3-js
			.filter(() => {
				if (d3.event.type === 'wheel') {
				  // don't allow zooming without pressing [ctrl] key
				  return d3.event.ctrlKey;
				}			
				return true;
			})
			.on("zoom", function () {
	    		svg.attr("transform", d3.event.transform)
			})
		)
		.on("click.zoom", null) // deactivate click on zoom
		.on("dblclick.zoom", null) // deactivate doubleclick on zoom
	    .append("g"); // Pan & Zoom trick...


	let node;
	let link;

	// div for tooltip
	let div = d3.select("body").append("div")	
	   .attr("class", "tooltip")				
	   .style("opacity", 0);

	svg.append('defs')
		.append('marker')
		.attr('id','arrowhead')
		.attr('viewBox','-0 -5 10 10')
		.attr('refX',RADIUS)
		.attr('refY',0)
		.attr('orient','auto')
		.attr('markerWidth',13)
		.attr('markerHeight',13)
		.attr('xoverflow','visible')
		.append('svg:path')
		.attr('d', 'M 0,-5 L 10 ,0 L 0,5')
		.attr('fill', 'grey')
		.attr('opacity', '0.9')
		.style('stroke','none');

	let simulation = d3.forceSimulation()
	    .force("link", d3.forceLink().id(function (d) {return d.id;}).distance(100).strength(1))
	    .force("charge", d3.forceManyBody().strength(-3000))
	    .force("center", d3.forceCenter(width / 2, height / 2));


	update(links, nodes);

	function update(links, nodes) {
		
	    link = svg.selectAll(".link")
	        .data(links)
	        .enter()
	        .append("line")
	        .attr("class", "link")
	        .attr('marker-end','url(#arrowhead)')
			;        

	    
	    link.append("g")
	        .text(function (d) {return d.source;})        
	       	;

	    edgepaths = svg.selectAll(".edgepath")
	        .data(links)
	        .enter()
	        .append('path')
	        .attr('class','edgepath')
	        .attr('fill-opacity',0)
	        .attr('stroke-opacity',9)
	        .attr('id',function (d, i) {return 'edgepath' + i;})
	        .style("pointer-events", "none")
	        ;

	    // links label placeholder
	    edgelabels = svg.selectAll(".edgelabel")
	        .data(links)
	        .enter()
	        .append('text')
	        .style("pointer-events", "auto")
	        .attr('class', 'edgelabel')
	        .attr('id', function (d, i) {return 'edgelabel' + i;})
	        .attr('font-size', 9)
	        .attr('fill', '#aaa')
	        ;

	    // links label
	    edgelabels.append('textPath')
	        .attr('xlink:href', function (d, i) {return '#edgepath' + i})
	        .style("text-anchor", "middle")        
	        .style("pointer-events", "auto")
			// tooltip events
			.on("mouseover", function(d) {		
	            div.transition()		
	                .duration(100)		
	                .style("opacity", .9);		
	            div.html("<b>" + d.source.id + " &rarr; " + d.target.id + "</b><br/>" +
	            		"From : <b>" + decodeURIComponent(escape(d.sourceLabel)) + "</b><br/>" +
	            		"To : <b>" + decodeURIComponent(escape(d.targetLabel)) + "</b><br/>" +
	            		"Link: <b>" + d.linkLabel + "</b><br/>"
	                    ) 
	                .style("left", (d3.event.pageX + 25) + "px")		
	                .style("top", (d3.event.pageY - 30) + "px");
	            })					
	        .on("mouseout", function(d) {		
	            div.transition()		
	                .duration(500)		
	                .style("opacity", 0);	
	        })
	        .attr("startOffset", function(d){ return "50%";}) 
	        .text(function (d) {return decodeURIComponent(escape(d.linkLabel));})
	        ;
	   
	    node = svg.selectAll(".node")
	        .data(nodes)
	        .enter()
	        .append("g")
	        .attr("class", "node")
	        .call(d3.drag()
				.on("start", dragstarted)
				.on("drag", dragged)
				.on("end", dragended)
	        )        
	        // tooltip events
			.on("mouseover", function(d) {		
	            div.transition()		
	                .duration(100)		
	                .style("opacity", .9);		
	            div.html("Node : <b>" + d.id + "</b><br/>" + 
	            		"Label : <b>" +  (d.label != undefined ? decodeURIComponent(escape(d.label.slice(0))) : "") + "</b><br/>"
	            		)            	 
	                .style("left", (d3.event.pageX + 25) + "px")		
	                .style("top", (d3.event.pageY - 30) + "px");
	            })					
	        .on("mouseout", function(d) {		
	            div.transition()		
	                .duration(500)		
	                .style("opacity", 0);	
	        })

	    node.append("circle")
	        .attr("r", RADIUS)
			.style("fill", function(d,i){ return colors(i);})
	        .style("cursor", "pointer") // pointer        
	        ;

	    // node label : id
	    node.append("text")
	        .attr("dy", -5)
	        .attr("text-anchor", "middle")
	        .attr("font-size", "11px")
	        .text(function (d) {return d.id;})
			;

		// node label : label
	    node.append("text")
		    .attr("dy", +10)
		    .attr("text-anchor", "middle")
		    .attr("font-size", "9px")
			.attr("color", "lightgreay")
		    .text(function (d) {
		    	let name = "";
		    	if(d.label != undefined) { name=(d.label.length>11) ? decodeURIComponent(escape(d.label.slice(0,-1).substr(0,11)))+"..." : d.label.slice(0); } // slice to remove quotes 
		    	return name;})
		    ;

	    simulation
	        .nodes(nodes)
	        .on("tick", ticked);

	    simulation.force("link")
	        .links(links);

	}
	
	function ticked() {
	    link
	        .attr("x1", function (d) {return d.source.x;})
	        .attr("y1", function (d) {return d.source.y;})
	        .attr("x2", function (d) {return d.target.x;})
	        .attr("y2", function (d) {return d.target.y;});

	    node.attr("transform", function (d) {return "translate(" + d.x + ", " + d.y + ")";});

	    edgepaths.attr('d', function (d) {
	    	return arcPath(d);
	    });

	    edgelabels.attr('transform', function (d) {
	        let bbox = this.getBBox();

	        rx = bbox.x + bbox.width / 2;
	        ry = bbox.y + bbox.height / 2;
	        
	        if (d.target.x < d.source.x) { // when target to the left of source
	            return 'rotate(180 ' + rx + ' ' + ry + ')';
	        }      

	    });
	}

	function dragstarted(d) {
	    if (!d3.event.active) simulation.alphaTarget(0.3).restart()
	    d.fx = d.x;
	    d.fy = d.y;
	}

	function dragged(d) {
	    d.fx = d3.event.x;
	    d.fy = d3.event.y;
	}

	function dragended(d) {
		simulation.stop();
	}

	function arcPath(d) {
	    let x1 = d.source.x,
	    y1 = d.source.y,
	    x2 = d.target.x,
	    y2 = d.target.y,
	    dx = x2 - x1,
	    dy = y2 - y1,
	    dr = Math.sqrt(dx * dx + dy * dy),

	    // Defaults for normal edge.
	    drx = 0, //dr,
	    dry = 0, //dr,
	    xRotation = 0, // degrees
	    largeArc = 0, // 1 or 0
	    sweep = 1; // 1 or 0

	    // Self edge.           
		if ( d.source.id === d.target.id) { // if ( x1 === x2 && y1 === y2 ) {      
	      xRotation = -45; // Fiddle with this angle to get loop oriented.
	      largeArc = 1; // Needs to be 1.
	      sweep = 0; // Change sweep to change orientation of loop.
	      // Make drx and dry different to get an ellipse
	      // instead of a circle.
	      drx = 25;
	      dry = 35;      
	      // For whatever reason the arc collapses to a point if the beginning
	      // and ending points of the arc are the same, so kludge it.
	      x2 = x2 + 1;
	      y2 = y2 + 1;
	    } 

		return "M" + x1 + "," + y1 + "A" + drx + "," + dry + " " + xRotation + "," + largeArc + "," + sweep + " " + x2 + "," + y2;
	}


}

// Reset svg
function resetSvg() {
	// reset any error message
	d3.select("#errorMsg").style("display","none").html("");
	// reset summary
	d3.select("#summary").style("display","none").html("");
	// remove all pre-existing elements in svg 
	d3.select("#svg").selectAll("*").remove();
	// empty table
	d3.select("#tbody-id").selectAll("tr").remove();
}

//handle window resizing
function resize() {
	let w = window.innerWidth;
	let h = window.innerHeight;
	d3.select('#chart svg').attr('width', w).attr('height', h);
}
window.onresize = resize;

// Export svg
function saveAsSvg(){
    let svg_data = document.getElementById("svg").innerHTML;
    let head = '<svg title="graph" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">';
    let style = '<style>circle {cursor: pointer;stroke: lightgrey;stroke-width: 1.5px;}text {font-family: sans-serif; fill: black;}path {stroke: #999;stroke-width: 1px;opacity:0.7}</style>';
    let full_svg = head +  style + svg_data + "</svg>";
    let blob = new Blob([full_svg], {type: "image/svg+xml;charset=utf-8"});  
    saveAs(blob, "graph-export.svg");
};

//Set-up the export button
d3.select('#btnExport').on('click', function(){
	console.log("export click...");
	d3.select('#svg').attr('width', window.innerWidth).attr('height', window.innerHeight);
	saveAsSvg();
});
</script>
</body>
</html>
