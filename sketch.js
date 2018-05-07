var number = 0;
var clickerCount = 0;
var ramp = 0;
var wave = [];
var retrig;

function setup(){
    createCanvas(windowWidth, windowHeight);
    background(0);
    loadSign();

    for (var i = 0; i < 128; i++) {
        wave.push(new Arcs(i));
        wave[i].init();
    }
}

function draw() {
    if (csoundLoaded && clickerCount == 0) {
        renderSq();
    }
    if (csoundLoaded && clickerCount > 0) {
        for (var i = 0; i < wave.length; i++) {
            wave[i].update();
            wave[i].draw();
        }
    }
}

function mouseClicked() {
    if (clickerCount == 0) {
        clear();
        background(0);
        clickerCount++;
        cs.audioContext.resume();
        cs.start();
    }
}

function windowResized() {
    resizeCanvas(windowWidth, windowHeight);
    background(0);
}

function loadSign() {
    stroke(255);
    fill(255);
    textAlign(CENTER);
    textFont("Verdana")
    text("loading...", windowWidth/2, windowHeight/2)
}

function renderSq() {
    fill(number);
    stroke(255);

    rectMode(CENTER);
    rect(windowWidth/2, windowHeight/2, 100, 50);
    textAlign(CENTER);
    textFont("Verdana")
    fill(0);
    stroke(0);
    text("render", windowWidth/2, windowHeight/2)

    number = ((number + 0.1) % 100)+ 50;
}

function Arcs(index) {
    this.index = index;
    this.offset = this.index * 2;
    this.number = 0 - this.offset;
    this.angle;
    this.reposition = function() {
        this.x = newX + this.index * random(0,5);
        this.y = newY + this.index * random(0,5);
    }
    this.init = function() {
        this.angle = random(0.5, 2);
    }
    this.update = function() {
        this.number += 5;
    }
    this.draw = function() {
        noFill();
        if (this.number >= 0 && this.number < 256) {
            stroke(this.number);
        } else if (this.number == 500){
            this.number = 0 - this.offset;
            if (this.index == 0) {
                newX = random(0, windowWidth);
                newY = random(0, windowHeight);
            }
        } else {
            stroke(0);
        }
        arc(100 + this.index, 100 + this.index, this.index*2, this.index*2, this.index*0.05, this.angle+this.index*0.05);
    }
}
