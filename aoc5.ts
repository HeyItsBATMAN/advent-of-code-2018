import { printTime } from './printtime';
import { readFileSync, existsSync } from 'fs';
import { basename } from 'path';
import { performance } from 'perf_hooks';
const inFile = basename(__filename, '.ts');
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
			if (input[i] !== undefined) {
				if (input[i] === input[i].toUpperCase()) {
					if (input[i].toLowerCase() === input[i - 1]) {
						input.splice(i - 1, 2);
					}
				} else {
					if (input[i].toUpperCase() === input[i - 1]) {
						input.splice(i - 1, 2);
					}
				}
			}
		}
	}
	return { result: input.length };
};

// Part two
const partTwo = (input) => {
	const results = [];
	const alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
	alphabet.forEach(char => {
		const newInput = input.filter(letter => letter.toLowerCase() !== char);
		results.push({ letter: char, result: partOne(newInput).result});
	});
	return results.sort((a, b) =>  a.result - b.result)[0];
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOne(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(partOneResult.result);
time1 = process.hrtime();
const partTwoResult = partTwo(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(partTwoResult.result);
