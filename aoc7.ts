import { readFileSync, existsSync } from 'fs';
import { basename } from 'path';
import { performance } from 'perf_hooks';
const inFile = basename(__filename, '.ts');
if (!existsSync(`./${inFile}.txt`)) {
	console.log('File not loaded... Exiting');
	process.exit(0);
}
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('\n');
console.log('File imported');
const exSplit = `Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.`.split('\n');

// Part one
const partOne = (array) => {
	let steps = [];
	array.map(step => {
		const stepRequired = step.split(' ')[1];
		if (steps.filter(v => v.letter === stepRequired).length < 1) {
			steps.push({
				letter: stepRequired,
				required: [],
				done: false
			});
		}
		const stepFor = step.split(' ')[7];
		const filter = steps.filter(v => v.letter === stepFor);
		if (filter.length > 0) {
			filter.map(v => {
				v['required'].push(stepRequired);
			});
		} else {
			const arr = [];
			arr.push(stepRequired);
			steps.push({
				letter: stepFor,
				required: arr,
				done: false
			});
		}
		return step;
	});
	steps = steps.sort((a, b) => (a.letter < b.letter) ? -1 : (a.letter > b.letter) ? 1 : 0);
	const returnData = JSON.parse(JSON.stringify(steps));
	let result = '';
	while (steps.filter(v => !v.done).length > 0) {
		let reset = false;
		steps.forEach(step => {
			if (!reset) {
				if (step.required.length === 0 && !step.done) {
					step.done = true;
					result += step.letter;
					reset = true;
				}
				step.required.forEach((req, reqIndex) => {
					steps.filter(v => req === v.letter && v.done).forEach(v => {
						if (!reset) {
							step.required.splice(reqIndex, 1);
							reset = true;
						}
					});
				});
			}
		});
	}
	return { array: array, data: returnData, result: result };
};

// Part two
const partTwo = (steps, maxWorkers, offset) => {
	let result = 0;
	steps.forEach((step, index) => {
		step['duration'] = 1 + offset + index;
	});
	const workers = [];
	while (steps.filter(v => !v.done).length > 0) {
		let somethingDone = false;
		for (let i = 0; i < maxWorkers; i++) {
			steps.forEach(step => {
				step.required.forEach((req, reqIndex) => {
					steps.filter(v => req === v.letter && v.done).forEach(v => {
						step.required.splice(reqIndex, 1);
					});
				});
				if (step.required.length === 0 && !step.done && workers.length < maxWorkers && workers.indexOf(step.letter) === -1) {
					workers.push(step.letter);
				}
			});
			steps.filter(step => step.letter === workers[i] && !step.done).forEach(step => {
				step.duration--;
				somethingDone = true;
				if (step.duration === 0) {
					step.done = true;
					workers.splice(i, 1);
				}
			});
		}
		if (somethingDone) result++;
	}
	return { result: result };
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
const partTwoResult = partTwo(partOne(finSplit).data, 5, 60);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2: ' + printTime(restime));
console.log(partTwoResult.result);
