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
const finSplit = readFileSync(`./${inFile}.txt`).toString();
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Import:\t' + printTime(restime));
const exSplit = `9 players; last marble is worth 25 points`;

// List implementation
interface Marble {
	value: number;
	prev?: Marble;
	next?: Marble;
}

const List = (marble: Marble, value): Marble => {
	const newMarble: Marble = {
		value,
		prev: marble,
		next: marble.next
	};
	marble.next.prev = newMarble;
	marble.next = newMarble;
	return newMarble;
};

// Part one
const partOne = (input) => {
	let currentMarble: Marble = {	value: 0 };
	currentMarble.next = currentMarble;
	currentMarble.prev = currentMarble;
	const [players, highest] = [parseInt(input.split(' ')[0], 10), parseInt(input.split(' ')[6], 10)];
	const playerScore = [];
	let currentPlayer = 1;
	for (let i = 1; i <= players; i++) {
		playerScore.push({player: i, score: 0});
	}
	for (let m = 1; m <= highest; m++) {
		if (m % 23 === 0) {
			currentMarble = currentMarble.prev.prev.prev.prev.prev.prev;
			playerScore[currentPlayer - 1].score += m + currentMarble.prev.value;
			currentMarble.prev.prev.next = currentMarble;
			currentMarble.prev = currentMarble.prev.prev;
		} else {
			currentMarble = List(currentMarble.next, m);
		}
		currentPlayer = currentPlayer % players + 1;
	}
	return { result: playerScore.sort((b, a) => a.score - b.score)[0] };
};

// Part two
const partTwo = (input) => {
	return partOne(input.replace(input.split(' ')[6], parseInt(input.split(' ')[6], 10) * 100));
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOne(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(partOneResult.result.score);
time1 = process.hrtime();
const partTwoResult = partTwo(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(partTwoResult.result.score);
