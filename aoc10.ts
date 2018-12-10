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
const finSplit = readFileSync(`./${inFile}.txt`).toString().split('\n');
let time2 = process.hrtime();
let restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Import:\t' + printTime(restime));
const exSplit = `position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>`.split('\n');

// Part one
const partOne = (array) => {
	const pos = [];
	const vel = [];

	const quickMoveMinMax = (arr) => {
		let minY = arr[0][1], maxY = arr[0][1], minX = arr[0][0], maxX = arr[0][0];
		for (let i = 1, len = arr.length; i < len; i++) {
			const y = arr[i][1];
			minY = (y < minY) ? y : minY;
			maxY = (y > maxY) ? y : maxY;
			const x = arr[i][0];
			minX = (x < minX) ? x : minX;
			maxX = (x > maxX) ? x : maxX;
		}
		return [minX, maxX, minY, maxY];
	};

	for (let i = 0; i < array.length; i++) {
		pos.push(array[i].substring(array[i].indexOf('<') + 1, array[i].indexOf('>')).split(',').map(v => parseInt(v, 10)));
		vel.push(array[i].substring(array[i].lastIndexOf('<') + 1, array[i].lastIndexOf('>')).split(',').map(v => parseInt(v, 10)));
	}

	const [minPosX, maxPosX, minPosY, maxPosY] = quickMoveMinMax(pos);
	let [leastX, leastY] = [Math.abs(minPosX - maxPosX) + 1, Math.abs(minPosY - maxPosY) + 1];

	const doMoves = (time) => {
		const moves = [];
		for (let c = 0; c < pos.length; c++) {
			const moveY = pos[c][1] + vel[c][1] * time;
			const moveX = pos[c][0] + vel[c][0] * time;
			moves.push([moveX, moveY]);
		}
		const [xMin, xMax, yMin, yMax] = quickMoveMinMax(moves);
		const [xBounds, yBounds] = [Math.abs(xMin - xMax), Math.abs(yMin - yMax)];
		return {xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, xBounds: xBounds, yBounds: yBounds};
	};

	for (let time = 0; true; time++) {
		const resMoves = doMoves(time);
		if (resMoves.xBounds + resMoves.yBounds < leastX + leastY) {
			leastX = resMoves.xBounds;
			leastY = resMoves.yBounds;
		} else {
			time--;
			const finMove = doMoves(time);
			const map = new Array(finMove.yBounds + 1).fill(0).map(v => v = new Array(finMove.xBounds + 1).fill(' '));
			for (let c = 0; c < pos.length; c++) {
				map[(pos[c][1] - finMove.yMin) + vel[c][1] * time][(pos[c][0] - finMove.xMin) + vel[c][0] * time] = '█';
			}
			map.forEach(row => console.log(row.join('')));
			return { time: time, message: 'See above' };
		}
	}
};

// Part two
const partTwo = (input) => {
	return input.time;
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOne(finSplit);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(partOneResult.message);
time1 = process.hrtime();
const partTwoResult = partTwo(partOneResult);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(partTwoResult);
