var number = 0;
var clickerCount = 0;
var ramp = 0;

var meow = [];

function setup(){
    createCanvas(windowWidth, windowHeight);
    background(0);

    for (var i = 0; i < 2; i++) {
        meow.push(new Circle(i));
        meow[i].init();
    }

    stroke(255);
    textAlign(CENTER);
    textFont("Verdana")
    text("loading...", windowWidth/2, windowHeight/2)
}

function draw() {
    if (csoundLoaded && clickerCount == 0) {
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
    if (csoundLoaded && clickerCount > 0) {

        noStroke();
        for (var i = 0; i < meow.length; i++) {
            meow[i].update();
            meow[i].draw();
        }
        if (ramp < 1) {
            ramp = ramp + 0.003;
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

function Circle() {

    this.positionX;
    this.positionY;

    this.positionXo;
    this.positionYo;
    this.positionXn;
    this.positionYn;

    this.stepx = (this.positionXn - this.positionXo)/128;
    this.stepy = (this.positionYn - this.positionYo)/128;

    this.number = Math.floor(random(0, 128));
    this.init = function() {
            this.positionXo = random(0, windowWidth);
            this.positionYo = random(0, windowHeight);
            this.positionXn = random(0, windowWidth);
            this.positionYn = random(0, windowHeight);

            this.stepx = (this.positionXn - this.positionXo)/128;
            this.stepy = (this.positionYn - this.positionYo)/128;

            this.positionX = this.positionXo;
            this.positionY = this.positionYo;


    }
    this.update = function() {
        this.number = (this.number + 1)% 128;
        this.positionX = this.positionX + this.stepx;
        this.positionY = this.positionY + this.stepy;
        if (this.number == 0) {
            this.init();
        }
    }
    this.draw = function() {
        noFill()
        stroke((Math.abs(64-this.number)*2)*ramp);
        arc(this.positionX, this.positionY, (Math.abs(this.number-64)*2), (Math.abs(this.number-64)*2), 0+this.number*0.01, 1.1+this.number*0.1);
    }
}
