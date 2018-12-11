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
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('\n').map(v => parseInt(v, 10))[0];
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Import:\t' + printTime(restime));
const exSplit = `18`.split('\n').map(v => parseInt(v, 10))[0];

// Shared
const printGrid = (startx, starty, size, coords) => {
	for (let y = starty; y < starty + size; y++) {
		let row = '';
		for (let x = startx; x < startx + size; x++) {
			row += coords[y][x] + '\t';
		}
		console.log(row);
	}
};

const highestSumOfGridSize = (coords, gridSize) => {
	let highest = {	y: 0, x: 0,	sum: 0 };
	for (let y = 0; y <= coords.length - gridSize; y++) {
		for (let x = 0; x <= coords[0].length - gridSize; x++) {
			const rows = {};
			let sum = 0;
			for (let gy = 0; gy < gridSize; gy++) {
				// Bold assumption
				if (sum < 0) continue;
				for (let gx = 0; gx < gridSize; gx++) {
					sum += coords[y + gy][x + gx];
				}
			}
			if (sum > highest.sum) {
				highest = {
					x: x,
					y: y,
					sum: sum
				};
			}
		}
	}
	return highest;
};

// Part one
const partOne = (serial) => {
	const calcPowerLevel = (xi, yi, sn) => {
		xi++;
		yi++;
		// Find the fuel cell's rack ID, which is its X coordinate plus 10
		const rackid = xi + 10;
		// Begin with a power level of the rack ID times the Y coordinate
		let powerlevel = rackid * yi;
		// Increase the power level by the value of the grid serial number (your puzzle input)
		powerlevel += sn;
		// Set the power level to itself multiplied by the rack ID
		powerlevel *= rackid;
		// Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0)
		powerlevel = Math.floor((powerlevel / 100) % 10);
		// Subtract 5 from the power level
		powerlevel -= 5;
		return powerlevel;
	};
	// Map (xi, yi still shifted by one)
	const coords = new Array(301).fill(0).map(v => new Array(301).fill(0));
	for (let y = 0; y <= 300 ; y++) {
		for (let x = 0; x <= 300; x++) {
			coords[y][x] = calcPowerLevel(x, y, serial);
		}
	}

	const highest = highestSumOfGridSize(coords, 3);

	printGrid(highest.x, highest.y, 3, coords);

	return { x: highest.x + 1, y: highest.y + 1, sum: highest.sum, coords: coords, serial: serial};
};

// Part two
const partTwo = (obj) => {
	const coords = obj.coords;
	const serial = obj.serial;

	let highest = {x: 0, y: 0, sum: 0, size: 0};
	for (let i = 1; i < 300; i++) {
		const newHighest = highestSumOfGridSize(coords, i);
		if (newHighest.sum > highest.sum) {
			highest = {...newHighest, size: i};
		}
	}
	highest.x++;
	highest.y++;

	return highest;
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOne(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(partOneResult.x + ',' + partOneResult.y);
time1 = process.hrtime();
const partTwoResult = partTwo(partOneResult);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(partTwoResult);
