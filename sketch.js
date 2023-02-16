import { SeirParameters, GetSeirContext, simTi } from './TriangularDistribution.js';

let rightX = 0;
let topH = 0;
let bottomH = 0;
let leftX = 0;
let graphAreaHeight = 0;

let context = {};
let parameters = {};
let duration = 0;
let simStarted = false;
let simTime = 0;

let yDens = 1;
let yDensSeir = 1;
let xDens = 1;

let healedColor = 0;
let infectedColor = 0;
let colorS = 0;
let colorE = 0;
let colorI = 0;
let colorR = 0;
let colorD = 0;

function setup() {
    createCanvas(Math.max(650, windowWidth), Math.max(800, windowHeight * 1.2));
    frameRate(60);
    sizeAreas();
    healedColor = color(20, 180, 50);
    infectedColor = color(180, 50, 200);
    colorS = color(50, 100, 180);
    colorE = color(120, 0, 0);
    colorI = color(250, 0, 0);
    colorR = healedColor;
    colorD = color(140, 50, 50);
    //textFont('Georgia');
    textFont('Helvetica');
    textStyle(NORMAL);
    textSize(12);

    drawGraphLines();
}

function draw() {
    
    if (simStarted) {
        background(255);
        drawGraphLines();
        if (window.isParametersToBeShown) {
            writeInfo();
        }
        drawTi();
        drawSeirValues();
        drawHtValues();
        drawTriangle(simTime)
        if (frameCount % 6 == 0) {
            simTime = context.next(parameters);
        }

        if (simTime == duration) {
            stopSim();
        }
    }
}

const drawGraphLines = () => {
    let y = topH;
    fill(0)
    stroke(2);
    strokeWeight(1);
    drawArow({ x: leftX, y: y }, { x: rightX + 20, y: y }, true);
    noStroke();
    text("t : days", leftX + 10, y + 18);

    y += graphAreaHeight;
    stroke(2);
    drawArow({ x: leftX, y: y }, { x: rightX + 20, y: y }, true);
    noStroke();
    text("t : days", leftX + 10, y + 18);

    y += graphAreaHeight;
    stroke(2);
    drawArow({ x: leftX, y: y }, { x: rightX + 20, y: y }, true);
    noStroke();
    text("t : days", leftX + 10, y + 18);

    angleMode(DEGREES);
    push();
    translate(leftX, topH);
    rotate(-90);
    noStroke();
    text("Cases", 10, -8);
    stroke(2);
    drawArow({ x: 0, y: 0 }, { x: 150, y: 0 });

    translate(-graphAreaHeight, 0);
    noStroke();
    text("Ti : Daily Noval Cases", 10, -12);
    stroke(2);
    drawArow({ x: 0, y: 0 }, { x: 150, y: 0 });

    translate(-graphAreaHeight, 0);
    noStroke();
    text("Ht : Daily Removed", 10, -12);
    stroke(2);
    drawArow({ x: 0, y: 0 }, { x: 150, y: 0 });
    pop();
}

const drawSeirValues = () => {
    let y = topH;
    let x = leftX;
    textSize(12);
    strokeWeight(2);
    fill(colorS);
    noStroke();
    text("-- S : Susceptible", width - 150, y - graphAreaHeight + 30)
    for (let t = 0; t < context.S.length; t++) {
        x = leftX + t * xDens;
        let h = yDensSeir * context.S[t];
        circle(x, y - h, 2, 2);
    }
    strokeWeight(2);
    fill(colorI);
    noStroke();
    text("-- I : Infected", width - 150, y - graphAreaHeight + 60)
    for (let t = 0; t < context.I.length; t++) {
        x = leftX + t * xDens;
        let h = yDensSeir * context.I[t];
        circle(x, y - h, 2, 2);
    }
    strokeWeight(2);
    fill(colorR);
    noStroke();
    text("-- R : Recovered", width - 150, y - graphAreaHeight + 90)
    for (let t = 0; t < context.R.length; t++) {
        x = leftX + t * xDens;
        let h = yDensSeir * context.R[t];
        circle(x, y - h, 2, 2);
    }

    strokeWeight(2);
    fill(colorD);
    noStroke();
    text("-- D : Casualty", width - 150, y - graphAreaHeight + 120)
    for (let t = 0; t < context.D.length; t++) {
        x = leftX + t * xDens;
        let h = yDensSeir * context.D[t];
        circle(x, y - h, 2, 2);
    }
}

const drawTi = () => {
    let y = topH + graphAreaHeight;
    let x = leftX;
    //console.log(context);

    for (let i = 0; i < simTi.healed.length; i++) {
        let valHealed = minZero(simTi.healed[i]);
        let valInfected = minZero(simTi.infected[i]);
        strokeWeight(2);
        stroke(healedColor);
        line(x, y, x, y - (valHealed * yDens));
        if (valInfected != 0) {
            stroke(infectedColor);
            line(x, y - valHealed * yDens, x, y - ((valHealed + valInfected) * yDens));
        }
        x += xDens;
    }
}



const drawHtValues = () => {
    let y = topH + 2 * graphAreaHeight;
    let x = leftX;
    strokeWeight(2);
    stroke(healedColor);
    for (let value of context.Ht) {
        line(x, y, x, y - value * yDens);
        x += xDens;
    }
}

const drawTriangle = (t) => {
    let x0 = parameters.x_0;
    let c = parameters.c;
    let L = parameters.L;
    let t_inc = parameters.t_inc;
    let h = L; // only for visual ratio, nothing about real value of h
    let y = topH + graphAreaHeight + 4;
    let x = leftX;

    x += t * xDens;
    strokeWeight(1);
    // Leader lines
    line(x, y, x, y + 10);
    y += graphAreaHeight;
    line(x, y, x, y + 10);

    y -= graphAreaHeight;
    strokeWeight(2);
    stroke(healedColor);
    x -= ((t_inc + x0) * xDens);
    line(x, y, (x - (c * xDens)), (y + h * yDens));
    x -= (c * xDens);
    line(x, y + (h * yDens), x - (L - c) * xDens, y);

    //draw arrow
    let x1 = leftX + t * xDens - (t_inc + x0 + c) * xDens;
    let x2 = leftX + t * xDens;
    let y1 = 3 + y + h * yDens;
    let y2 = 3 + y + graphAreaHeight - 10;

    drawArow({ x: x1, y: y1 }, { x: x2, y: y2 });
}

const minZero = (num) => {
    return num > 0 ? num : 0;
}

export function SetContext(seirContext) {
    context = seirContext;
}

export function startSim(seirContext, seirParameters, timeDuration) {
    SetContext(seirContext);
    parameters = seirParameters;
    duration = timeDuration;
    console.log(duration);
    console.log(simTi);
    sizeDensities();
    simTi.healed = [];
    simTi.infected = [];
    simTime = 0;
    simStarted = true;
}

function windowResized() {
    resizeCanvas(Math.max(650, windowWidth), Math.max(800, windowHeight * 1.2));
    sizeAreas();
    if (simStarted) {
        sizeDensities();
    }
}
function sizeAreas() {
    rightX = width * 0.95;
    topH = height * 0.3;
    bottomH = height * 0.95;
    leftX = width * 0.05;
    graphAreaHeight = height * 0.5 / 2;

}

function sizeDensities() {
    yDens = 10 * graphAreaHeight / context.N[0];
    yDensSeir = graphAreaHeight / context.N[0];
    xDens = (rightX - leftX) / duration;
}

export function stopSim() {
    if (simStarted) {
        simStarted = false;
        return true;
    }
    return false;
}

function drawArow(fromP, toP, full = false) {
    let v1 = createVector(fromP.x, fromP.y);
    let v2 = createVector(toP.x - fromP.x, toP.y - fromP.y);
    let l = full ? v2.mag() : v2.mag() * 0.8;
    angleMode(RADIANS);
    let a = atan((toP.y - fromP.y) / (toP.x - fromP.x));
    push();
    translate(v1);
    rotate(a);
    let arrL = Math.min(20, 0.1 * l);
    line(l, 0, l - arrL, -arrL / 2);
    line(l, 0, l - arrL, arrL / 2);
    line(4, 0, l, 0);
    pop();
}

export function continueSim() {
    simStarted = true;
}

export function saveSim() {
    let wasStopped = stopSim();
    save("SEIR_Sim.png");
    if (wasStopped) {
        continueSim();
    }
}
// { bs: bs, gamma: gamma, k: k, t_inc: t_inc, t_h: t_h, x_0: x_0, c: c, L: L }
// s, e, i, r
function writeInfo() {
    noStroke();
    fill(0);
    text(`R_0 : ${context.R[0]}`, leftX, bottomH);
    text(`I_0 : ${context.I[0]}`, leftX, bottomH - 25);
    text(`E_0 : ${context.E[0]}`, leftX, bottomH - 50);
    text(`S_0 : ${context.S[0]}`, leftX, bottomH - 75);

    let offset = leftX + (rightX - leftX) / 3;
    text(`bs : ${parameters.bs}`, offset, bottomH - 75);
    text(`gamma : ${parameters.gamma}`, offset, bottomH - 50);
    text(`k : ${parameters.k}`, offset, bottomH - 25);
    text(`t_inc : ${parameters.t_inc}`, offset, bottomH);

    offset = leftX + (rightX - leftX) * 2 / 3;
    text(`t_h : ${parameters.t_h}`, offset, bottomH - 75);
    text(`x_0 : ${parameters.x_0}`, offset, bottomH - 50);
    text(`c : ${parameters.c}`, offset, bottomH - 25);
    text(`L : ${parameters.L}`, offset, bottomH);
}

window.setup = setup;
window.Continue = continueSim;
window.Save = saveSim;
window.draw = draw;
window.windowResized = windowResized;