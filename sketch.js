var number = 0;
var clickerCount = 0;
var ramp = 0;
var blob = [];
var retrig;

function setup(){
    createCanvas(windowWidth, windowHeight);
    background(0);
    loadSign();

    for (var i = 0; i < 20; i++) {
        blob.push(new Circle(i));
    }


}

function draw() {
    if (csoundLoaded && clickerCount == 0) {
        renderSq();
    }
    if (csoundLoaded && clickerCount > 0) {
        for (var i = 0; i < blob.length; i++) {
            blob[i].update();
            blob[i].draw();
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

function Circle(index) {
    this.index = index;

    this.ramp = 0 - (this.index*30)

    this.posX = randomGaussian(windowWidth/2, windowWidth/5);
    this.posY = randomGaussian(windowHeight/2, windowHeight/5);
    this.fill = random(0, 10);
    this.update = function() {
        if (this.ramp > 0) {
            this.randFill = random(-2,2);
            this.fill = this.fill + this.randFill
            if (this.fill < 0) {
                this.fill = 20;
            } else if (this.fill > 255) {
                this.fill = 235;
            }

            this.posX = this.posX + random(-4, 4);
            this.posY = this.posY + random(-4, 4);
        }


        if (this.ramp < 1) {
            this.ramp = this.ramp + 0.075;
        }


    }
    this.draw = function() {
        fill(this.fill * this.ramp);
        this.size = (200 - this.fill)*2
        if (this.size < 10) {
            this.size = 10;
        }
        noStroke();
        if (this.ramp >= 0) {
            ellipse(this.posX, this.posY, this.size, this.size);
        }
    }

}
