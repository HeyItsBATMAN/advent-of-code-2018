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
const exSplit = `1, 1
1, 6
8, 3
3, 4
5, 5
8, 9`.split('\n');

// Part one
const partOne = (array) => {
	const distance = (a, b) => {
		return Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]);
	};
	array = array.map((pair, index) => ({ id: index + 1, pair: [parseInt(pair.split(',')[0], 10), parseInt(pair.split(',')[1], 10)], count: 0 }));
	const xmax = array.sort((b, a) => a.pair[0] - b.pair[0])[0].pair[0];
	const ymax = array.sort((b, a) => a.pair[1] - b.pair[1])[0].pair[1];
	const coords = new Array(xmax).fill(0).map(y => y = new Array(ymax).fill(0));
	for (let x = coords[0].length - 1; x >= 0; x--) {
		for (let y = coords.length - 1; y >= 0; y--) {
			const sorted = array.sort((a, b) => distance([x, y], a.pair) - distance([x, y], b.pair));
			if (distance([x, y], sorted[0].pair) === distance([x, y], sorted[1].pair)) {
				coords[y][x] = 0;
			} else {
				coords[y][x] = sorted[0].id;
			}
		}
	}
	const results = [];
	array.forEach(point => {
		let isInfinite = false;
		const reduced = coords.map((y, yi) => {
			if (!isInfinite) {
				return y.filter((x, xi) => {
					if (!isInfinite) {
						if (((yi === 0 || xi === 0) || (yi === coords.length - 1 || xi === coords[0].length - 1)) && coords[yi][xi] === point.id) {
							isInfinite = true;
							return false;
						}
						return (x === point.id);
					} else {
						return false;
					}
				}).length;
			} else {
				return 0;
			}
		}).reduce((acc, v) => acc += v);
		results.push({id: point.id, count: reduced});
	});
	results.sort((b, a) => a.count - b.count);
	return {result: results[0], data: coords, array: array};
};

const partOnePerf = (array) => {
	const distance = (a, b) => {
		return Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]);
	};
	array = array.map((pair, index) => ({ id: index + 1, pair: [parseInt(pair.split(',')[0], 10), parseInt(pair.split(',')[1], 10)], count: 0 }));
	const xmax = array.sort((b, a) => a.pair[0] - b.pair[0])[0].pair[0];
	const ymax = array.sort((b, a) => a.pair[1] - b.pair[1])[0].pair[1];
	const coords = new Array(xmax).fill(0).map(y => y = new Array(ymax).fill(0));
	for (let x = coords[0].length - 1; x >= 0; x--) {
		for (let y = coords.length - 1; y >= 0; y--) {
			let lowestDist = {id: 0, distance: 99999};
			let secondLowest = {id: 0, distance: 99999};
			for (let i = 0; i < array.length; i++) {
				array[i]['distance'] = distance([x, y], array[i].pair);
				if (array[i]['distance'] < lowestDist.distance) {
					secondLowest = lowestDist;
					lowestDist = array[i];
				} else if (array[i]['distance'] > lowestDist.distance && array[i]['distance'] <= secondLowest.distance) {
					secondLowest = array[i];
				}
			}
			if (lowestDist.distance === secondLowest.distance) {
				coords[y][x] = 0;
			} else {
				coords[y][x] = lowestDist.id;
			}
		}
	}
	const results = [];
	for (let i = 0; i < array.length; i++) {
		const point = array[i];
		let count = 0;
		let isInfinite = false;
		for (let y = 0; y < coords.length; y++) {
			if (!isInfinite) {
				for (let x = 0; x < coords[0].length; x++) {
					if (!isInfinite && ((y === 0 || x === 0) || (y === coords.length - 1 || x === coords[0].length - 1)) && coords[y][x] === point.id) {
						isInfinite = true;
					} else if (coords[y][x] === point.id) {
						count++;
					}
				}
			}
		}
		results.push({id: point.id, count: count});
	}
	results.sort((b, a) => a.count - b.count);
	return {result: results[0], data: coords, array: array};
};

// Part two
const partTwo = (obj) => {
	let result = 0;
	const distance = (a, b) => {
		return Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]);
	};
	for (let x = obj.data[0].length - 1; x >= 0; x--) {
		for (let y = obj.data.length - 1; y >= 0; y--) {
			if (obj.array.reduce((acc, v) => acc += distance([x, y], v.pair), 0) < 10000) result++;
		}
	}
	return result;
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
const partOneResult = partOnePerf(finSplit);
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1: ' + printTime(restime));
console.log(partOneResult.result);
time1 = process.hrtime();
const partTwoResult = partTwo(partOneResult);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2: ' + printTime(restime));
console.log(partTwoResult);

