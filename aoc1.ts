import { readFileSync } from 'fs';
import { performance } from 'perf_hooks';
const finSplit = readFileSync('./aoc1.txt').toString().split('\n').map(sval => parseInt(sval, 10));

// PART ONE:
const calcFrequency = (array) => {
	return array.reduce((acc, val) => acc += val);
};

// PART TWO:
const firstTwice = (array) => {
	let start = 0;
	const set = new Set();
	while (true) {
		for (let i = 0; i <= array.length - 1; i++) {
			start += array[i];
			const prev = set.size;
			if (prev === set.add(start).size) {
				return start;
			}
		}
	}
};

let time = performance.now();
console.log(calcFrequency(finSplit));
console.log('Part 1: ' + ((performance.now() - time) / 1000));
time = performance.now();
console.log(firstTwice(finSplit));
console.log('Part 2: ' + ((performance.now() - time) / 1000));

