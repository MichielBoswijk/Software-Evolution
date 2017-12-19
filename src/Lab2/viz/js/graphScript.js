var diameter = window.innerWidth / 2.2,
    radius = diameter / 2,
    innerRadius = radius - 120;

var cluster = d3.cluster()
    .size([360, innerRadius]);

var line = d3.radialLine()
    .curve(d3.curveBundle.beta(0.85))
    .radius(function(d) { return d.y; })
    .angle(function(d) { return d.x / 180 * Math.PI; });

var svg = d3.select("#left-section").append("svg")
    .attr("width", diameter + 100)
    .attr("height", diameter)
  .append("g")
    .attr("transform", "translate(" + radius + "," + radius + ")");

var link = svg.append("g").selectAll(".link"),
    node = svg.append("g").selectAll(".node");

var filePath = "data/final.json";
if (document.cookie) {
  var filePath = "data/" + document.cookie;  
}

d3.json(filePath, function(error, classes) {
  if (error) throw error;

  var root = packageHierarchy(classes)
      .sum(function(d) { return d.size; });

  cluster(root);

  link = link
    .data(packageImports(root.leaves()))
    .enter().append("path")
      .each(function(d) { d.source = d[0], d.target = d[d.length - 1]; })
      .attr("class", "link")
      .attr("d", line);

  node = node
    .data(root.leaves())
    .enter().append("text")
      .attr("class", "node")
      .attr("dy", "0.31em")
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 8) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
      .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
      .text(function(d) { return d.data.name.split('/')[6]; })
      .on("mouseover", mouseovered)
      .on("mouseout", mouseouted)
      .on("click", mouseclicked);
});

function mouseovered(d) {

  document.getElementById("name").innerHTML = d.data.name.slice(31);
  document.getElementById("loc").innerHTML = d.data.size;
  document.getElementById("duplication").innerHTML = d.data.duplication;
  // document.getElementById("nClones").innerHTML = d.data.nclones;
  document.getElementById("nClasses").innerHTML = d.data.nclasses;

  readTextFile('/home/michiel/Desktop/CloneVisualization/classes/' + d.data.name.split('/')[d.data.name.split('/').length - 1].replace('.java', '.txt'));
  load_js();

  console.log(d.data.name.slice(9));

  node
      .each(function(n) { n.target = n.source = false; });

  link
      // .classed("link--target", function(l) { if (l.target === d) return l.source.source = true; })
      .classed("link--source", function(l) { if (l.source === d) return l.target.target = true; })
    .filter(function(l) { return l.target === d || l.source === d; })
      .raise();

  node
      // .classed("node--target", function(n) { return n.target; })
      .classed("node--source", function(n) { return n.source; });
}

function mouseouted(d) {
  link
      // .classed("link--target", false)
      .classed("link--source", false);

  node
      // .classed("node--target", false)
      .classed("node--source", false);
}

function mouseclicked(d) {
  var loc = d.data.link;
  // console.log(loc.slice(11, -1));
  window.open(loc.slice(10));
}


// Lazily construct the package hierarchy from class names.
function packageHierarchy(classes) {
  var map = {};

  function find(name, data) {
    var node = map[name], i;
    if (!node) {
      node = map[name] = data || {name: name, children: []};
      console.log(typeof node);
      if (name.length) {
        node.parent = find(name.substring(0, i = name.lastIndexOf(".")));
        node.parent.children.push(node);
        node.key = name.substring(i + 1);
      }
    }
    return node;
  }

  classes.forEach(function(d) {
    find(d.name, d);
  });



  return d3.hierarchy(map[""]);
}


function packageHierarchy(classes) {
  var map = {};

  function find(name, data) {
    var node = map[name], i;
    if (!node) {
      node = map[name] = data || {name: name, children: []};
      if (name.length) {
        node.parent = find(name.substring(0, i = name.lastIndexOf(".")));
        node.parent.children.push(node);
        node.key = name.substring(i + 1);
      }
    }
    return node;
  }

  classes.forEach(function(d) {
    find(d.name, d);
  });

  return d3.hierarchy(map[""]);
}

// Return a list of imports for the given array of nodes.
function packageImports(nodes) {
  var map = {},
      imports = [];

  // Compute a map from name to node.
  nodes.forEach(function(d) {
    map[d.data.name] = d;
  });

  // For each import, construct a link from the source to target node.
  nodes.forEach(function(d) {
    if (d.data.imports) d.data.imports.forEach(function(i) {
      imports.push(map[d.data.name].path(map[i]));
    });
  });

  return imports;
}


function readTextFile(file)
{
    fileDisplayArea = document.getElementById('codeblock');
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", file, false);
    rawFile.onreadystatechange = function ()
    {
        if(rawFile.readyState === 4)
        {
            if(rawFile.status === 200 || rawFile.status == 0)
            {
                var allText = rawFile.responseText;
                fileDisplayArea.innerHTML = allText;
            }
        }
    }
    rawFile.send(null);
}

///////////////////////////////////////////////////////////////////////

function load_js()
   {
      var head= document.getElementsByTagName('head')[0];
      var script= document.createElement('script');
      script.type= 'text/javascript';
      script.src= 'js/prism.js';
      head.appendChild(script);
   }
   load_js();


function sortSize() {
  // document.cookie = "sizeAllFiles.json";
  // document.cookie = "sizeSelectedFiles.json";
  document.cookie = "final.json";
  location.reload();
}

function sortName() {
  // document.cookie = "namesAllFiles.json";
  // document.cookie = "namesSelectedFiles.json";
  document.cookie = "final.json";
  location.reload();
}

function sortClones() {
  // document.cookie = "clonesAllFiles.json";
  // document.cookie = "clonesSelectedFiles.json";
  document.cookie = "final.json";
  location.reload();
}

function sortDuplication() {
  // document.cookie = "duplicationAllFiles.json";
  // document.cookie = "duplicationSelectedFiles.json";
  document.cookie = "final.json";
  location.reload();
}