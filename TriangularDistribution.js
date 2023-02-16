"use strict"

export const SeirParameters = (bs, gamma, k, t_inc, t_h, x_0, c, L) => {
    return { bs: bs, gamma: gamma, k: k, t_inc: t_inc, t_h: t_h, x_0: x_0, c: c, L: L }
};

export const GetSeirContext = (s, e, i, r) => {
    return {
        t: [0],
        S: [s],
        E: [e],
        I: [i],
        R: [r],
        D: [0],
        N: [s + e + i + r],
        Te: [0],
        Ti: [0],
        Ht: [0],
        next(parameters) { return NextSeirState(this, parameters); }
    }
};

export let simTi = { infected: [], healed: [] };

const NextSeirState = (seirContext, seirParameters) => {
    let bs = seirParameters.bs;
    let gamma = seirParameters.gamma;
    let k = seirParameters.k;
    let t = seirContext.S.length - 1;
    let t_inc = seirParameters.t_inc;
    //let t_h = seirParameters.t_h;
    let x_0 = seirParameters.x_0;
    let c = seirParameters.c;
    let L = seirParameters.L;
    let Te_t = GetTe(seirContext, t, bs);
    let Ti = GetTe(seirContext, t - t_inc, bs);
    simTi.infected.push(Ti ?? 0);
    simTi.healed.push(0);
    //let H_t = GetTe(seirContext, t - t_h, bs);
    let H_t = GetH(seirContext, t, t_inc, x_0, c, L);
    let R_s = Rs(seirContext, t, k);
    seirContext.S.push(GetS(seirContext, t) + R_s - Te_t);
    seirContext.E.push(GetE(seirContext, t) + Te_t - Ti);
    seirContext.I.push(GetI(seirContext, t) + Ti - H_t);
    seirContext.R.push(GetR(seirContext, t) + (1 - gamma) * H_t - R_s);
    seirContext.D.push(seirContext.D[t] + gamma * H_t);
    seirContext.N.push(seirContext.S.at(-1) + seirContext.E.at(-1) + seirContext.I.at(-1) + seirContext.R.at(-1));
    seirContext.Ti.push(Ti);
    seirContext.Te.push(Te_t);
    seirContext.Ht.push(H_t);
    seirContext.t.push(++t);
    return t;
};

const GetH = (seirContext, t, t_inc, x_0, c, L) => {
    let T_i = [];
    for (let ti = t - x_0; ti >= t - (x_0 + L); ti--) {
        let Ti_t = GetTi(seirContext, ti, t_inc);
        T_i.push(Ti_t);
    }    
    //console.log(`from ${t - (x_0 + L)} to ${t - x_0} : ` + T_i);
    let h_part1 = [];
    for (let x = 0; x < c+1; x++) {
        let h = p_1(x, c, L) * T_i[x];
        h_part1.push(h ?? 0);
    }
    let h_part2 = [];
    for (let x = c; x < L+1; x++) {
        let h = p_2(x, c, L) * T_i[x];
        h_part2.push(h ?? 0);
    }

    let healings = [...h_part1, ...(h_part2.slice(1))];
    //console.log(healings.length == T_i.length);
    //console.log(healings);
    for (let x = 0; x < healings.length; x++) {
        let ti = t - x_0 - x-1;
        if (ti >= 0) {
            simTi.infected[ti] -= (healings[x] ?? 0);
            simTi.healed[ti] += (healings[x] ?? 0);
        }
    }
    // let h = h_part1.reduce((sum, num) => sum + num, 0) + h_part2.reduce((sum, num) => sum + num, 0);
    let h = Trapez(h_part1) + Trapez(h_part2);
    return h;
};

const Trapez = (series, step = 1) => {
    let sum = 0;
    for (let x = 1; x < series.length; x++) {
        let y0 = series[x-1];
        let y1 = series[x];
        sum += step * (y0 + y1) / 2 
    }
    return sum;
};

const p_1 = (x, c, L) => {
    return (2 * x) / (L * c);
};

const p_2 = (x, c, L) => {
    return (2 * (L - x)) / (L * (L - c));
};

const GetTe = (seirContext, t, bs) => {
    if (t < 0) return 0;
    let S = GetS(seirContext, t);
    let I = GetI(seirContext, t);
    let N = seirContext.N[t];
    return bs * S * I / N;
};

const GetTi = (seirContext, t, t_inc) => {
    t = t - t_inc;
    if (t < 0) return 0;
    return seirContext.Te[t];
};

const Rs = (seirContext, t, k) => {
    let R = GetR(seirContext, t);
    return R * k;
};

const GetS = (seirContext, t) => {
    t = t < 0 ? 0 : t;
    return seirContext.S[t]
};

const GetE = (seirContext, t) => {
    t = t < 0 ? 0 : t;
    return seirContext.E[t];
};

const GetI = (seirContext, t) => {
    t = t < 0 ? 0 : t;
    seirContext.I[t];
    return seirContext.I[t];
};

const GetR = (seirContext, t) => {
    t = t < 0 ? 0 : t;
    seirContext.R[t];
    return seirContext.R[t];
};