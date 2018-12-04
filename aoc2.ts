import { readFileSync, existsSync } from 'fs';
import { basename } from 'path';
import { performance } from 'perf_hooks';
const inFile = basename(__filename).split('.')[0];
if (!existsSync(`./${inFile}.txt`)) {
	console.log('File not loaded... Exiting');
	process.exit(0);
}
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('\n');
console.log('File imported');
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
console.log(partOneResult);
time1 = process.hrtime();
const partTwoResult = partTwoPerf(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2: ' + printTime(restime));
console.log(partTwoResult);
