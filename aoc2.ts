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
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('\n');
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Import:\t' + printTime(restime));
const exSplit = ``.split('\n');

// PART ONE:
const partOne = (arr) => {
	const count = { '2': 0, '3': 0 };
	arr.map(box_id => {
		const id_chars = box_id.split('');
		return Array.from(new Set(id_chars.filter(char => {
			const length = id_chars.filter(v => v === char).length;
			return (length >= 2 && length <= 3);
		}).map(char => id_chars.filter(v => v === char).length)));
		}).map(obj => obj.map(box_id => count[(box_id === 2) ? '2' : '3']++));
	return count['2'] * count['3'];
};

const partOneShort = (arr) => {
	const count = { '2': 0, '3': 0 };
	arr.map(id => Array.from(new Set(id.split('').filter(char => (id.split('').filter(v => v === char).length >= 2 && id.split('').filter(v => v === char).length <= 3)).map(char => id.split('').filter(v => v === char).length)))).map(obj => obj.map(id => count[(id === 2) ? '2' : '3']++));
	return count['2'] * count['3'];
};

// PART TWO:
const partTwoShort = (array) => {
	const correct = new Set();
	array.map(oid => array
		.map(id => {
			const m = oid.split('').filter((c, i) => c === id[i]).join('');
			if (m.length === array[0].length - 1) correct.add(m);
		}));
	return Array.from(correct).reverse().join('');
};

const partTwoPerf = (array) => {
	let correct = '';
	const arrLen = array.length;
	for (let i = arrLen - 1; i >= 0; i--) {
		for (let j = arrLen - 2; j >= 0; j--) {
			correct = '';
			for (let x = 0; x < array[j].length; x++) {
				if (array[i][x] === array[j][x]) {
					correct += array[i][x];
				}
			}
			if (correct.length === array[0].length - 1) {
				return correct;
			}
		}
	}
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOne(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(partOneResult);
time1 = process.hrtime();
const partTwoResult = partTwoPerf(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(partTwoResult);
