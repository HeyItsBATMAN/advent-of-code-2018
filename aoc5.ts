import { printTime } from './printtime';
import { readFileSync, existsSync } from 'fs';
import { basename } from 'path';
import { performance } from 'perf_hooks';
const inFile = basename(__filename).split('.')[0];
if (!existsSync(`./${inFile}.txt`)) {
	console.log('File not loaded... Exiting');
	process.exit(0);
}
let time1 = process.hrtime();
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('');
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Import:\t' + printTime(restime));
const exSplit = `dabAcCaCBAcCcaDA`.split('');

// Part one
const partOne = (input) => {
	let lastSize = 0;
	while (lastSize !== input.length) {
		lastSize = input.length;
		for (let i = input.length - 1; i > 0; i--) {
			if (Math.abs(input[i].charCodeAt() - input[i - 1].charCodeAt()) === 32) input.splice(i - 1, 2);
		}
	}
	return { result: input.length };
};

const partOneHeap = (input) => {
	const stack = [input[0]];
	for (let i = 1; i < input.length; i++) {
		const s = stack[stack.length - 1];
		if (s && Math.abs(input[i].charCodeAt() - s.charCodeAt()) === 32) stack.pop();
		else stack.push(input[i]);
	}
	return { result: stack.length };
};

// Part two
const partTwo = (input) => {
	return 'abcdefghijklmnopqrstuvwxyz'.split('').map(char => {
		const newInput = input.filter(letter => letter.toLowerCase() !== char);
		return ({ letter: char, result: partOne(newInput).result});
	}).sort((a, b) =>  a.result - b.result)[0];
};

const partTwoPerf = (input) => {
	const arr = 'abcdefghijklmnopqrstuvwxyz'.split('');
	let result = partOneHeap(input.filter(letter => letter.toLowerCase() !== arr[0])).result;
	for (let i = 1; i < arr.length; i++) {
		const res = partOneHeap(input.filter(letter => letter.toLowerCase() !== arr[i])).result;
		if (res < result) result = res;
	}
	return { result: result };
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOneHeap(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(partOneResult.result);
time1 = process.hrtime();
const partTwoResult = partTwoPerf(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(partTwoResult.result);
