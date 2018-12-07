import { readFileSync, existsSync } from 'fs';
import { basename } from 'path';
import { performance } from 'perf_hooks';
const inFile = basename(__filename, '.ts');
if (!existsSync(`./${inFile}.txt`)) {
	console.log('File not loaded... Exiting');
	process.exit(0);
}
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('');
console.log('File imported');
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

// Make pretty time
const printTime = (time) => {
	let returnString = '';
	if (time / 1000 / 1000 > 1) {
		time = time / 1000 / 1000;
		return returnString += time.toString().substr(0, time.toString().indexOf('.') + 2) + 's';
	}
	if (time / 1000 > 1) {
		time = time / 1000;
		return returnString += time.toString().substr(0, time.toString().indexOf('.') + 2) + 'ms';
	}
	return returnString += time.toString().substr(0, time.toString().indexOf('.') + 2) + 'µs';
};

// Running and Benchmarking
let time1 = process.hrtime();
const partOneResult = partOne(finSplit);
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1: ' + printTime(restime));
console.log(partOneResult.result);
time1 = process.hrtime();
const partTwoResult = partTwo(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2: ' + printTime(restime));
console.log(partTwoResult.result);
