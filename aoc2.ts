import { readFileSync } from 'fs';
import { performance } from 'perf_hooks';
const finSplit = readFileSync('./aoctwitch.txt').toString().split('\n');

// PART ONE:
const checksum = (arr) => {
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

const checksumShort = (arr) => {
	const count = { '2': 0, '3': 0 };
	arr.map(id => Array.from(new Set(id.split('').filter(char => (id.split('').filter(v => v === char).length >= 2 && id.split('').filter(v => v === char).length <= 3)).map(char => id.split('').filter(v => v === char).length)))).map(obj => obj.map(id => count[(id === 2) ? '2' : '3']++));
	return count['2'] * count['3'];
};

// PART TWO:
const findCorrectBoxes = (arr) => {
	const correct = new Set();
	arr.map(oid => arr.map(id => {
			const m = oid.split('').filter((c, i) => c === id[i]).join('');
			if (m.length === arr[0].length - 1) correct.add(m);
		}));
	return Array.from(correct).reverse().join('');
};

let time = performance.now();
console.log(checksum(finSplit));
console.log('Part 1: ' + ((performance.now() - time) / 1000));
time = performance.now();
console.log(findCorrectBoxes(finSplit));
console.log('Part 2: ' + ((performance.now() - time) / 1000));
