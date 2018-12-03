import { readFileSync } from 'fs';
import { performance } from 'perf_hooks';
const finSplit = readFileSync('./aoc3.txt').toString().split('\n');
const exSplit = `#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2`.split('\n');

const partOne = (array) => {
	const boxes = [];
	// To Boxes
	array.forEach(claim => {
		const id = claim.split('@')[0];
		const xo = parseInt(claim.split('@')[1].split(':')[0].split(',')[0], 10);
		const yo = parseInt(claim.split('@')[1].split(':')[0].split(',')[1], 10);
		const x = parseInt(claim.split('@')[1].split(':')[1].split('x')[0], 10);
		const y = parseInt(claim.split('@')[1].split(':')[1].split('x')[1], 10);
		boxes.push({ id: id, xo: xo, yo: yo, x: x, y: y });
	});
	// Max X and Y
	const xmax = boxes.map(box => box.x + box.xo).reduce((a, b) => Math.max(a, b)) + 1;
	const ymax = boxes.map(box => box.y + box.yo).reduce((a, b) => Math.max(a, b)) + 1;
	// Map out
	const myMap = new Array(ymax);
	myMap.fill(0);
	for (let i = 0; i < myMap.length; ++i) {
		myMap[i] = new Array(xmax);
		myMap[i].fill(0);
	}
	// Box to map
	boxes.forEach(box => {
		for (let y = box.yo; y < box.yo + box.y; y++) {
			for (let x = box.xo; x < box.xo + box.x; x++) {
				myMap[y][x]++;
			}
		}
	});
	let count = 0;
	myMap.forEach(x => {
		x.forEach(y => {
			if (y > 1) count++;
		});
	});
	return count;
};

const partTwo = (array) => {
	const boxes = [];
	array.forEach(claim => {
		const id = claim.split('@')[0];
		const xo = parseInt(claim.split('@')[1].split(':')[0].split(',')[0], 10);
		const yo = parseInt(claim.split('@')[1].split(':')[0].split(',')[1], 10);
		const x = parseInt(claim.split('@')[1].split(':')[1].split('x')[0], 10);
		const y = parseInt(claim.split('@')[1].split(':')[1].split('x')[1], 10);
		boxes.push({ id: id, xo: xo, yo: yo, x: x, y: y });
	});
	// Max X and Y
	const xmax = boxes.map(box => box.x + box.xo).reduce((a, b) => Math.max(a, b)) + 1;
	const ymax = boxes.map(box => box.y + box.yo).reduce((a, b) => Math.max(a, b)) + 1;
	// Map out
	const myMap = new Array(ymax);
	myMap.fill(0);
	for (let i = 0; i < myMap.length; ++i) {
		myMap[i] = new Array(xmax);
		myMap[i].fill(0);
	}
	// Fill
	boxes.forEach(box => {
		for (let y = box.yo; y < box.yo + box.y; y++) {
			for (let x = box.xo; x < box.xo + box.x; x++) {
				myMap[y][x]++;
			}
		}
	});
	// Check
	let correctbox = '';
	boxes.forEach(box => {
		let isCorrect = true;
		for (let y = box.yo; (y < box.yo + box.y) && isCorrect; y++) {
			for (let x = box.xo; (x < box.xo + box.x) && isCorrect; x++) {
				if (myMap[y][x] > 1) {
					isCorrect = false;
				}
				if (x === (box.xo + box.x - 1) && y === (box.yo + box.y - 1)) {
					correctbox = box.id;
				}
			}
		}
	});
	return correctbox;
};

const partOneShort = (array) => {
	const boxes = array.map(claim => ({ id: claim.split('@')[0], xo: parseInt(claim.split('@')[1].split(':')[0].split(',')[0], 10), yo: parseInt(claim.split('@')[1].split(':')[0].split(',')[1], 10), x: parseInt(claim.split('@')[1].split(':')[1].split('x')[0], 10), y: parseInt(claim.split('@')[1].split(':')[1].split('x')[1], 10) }));
	const myMap = new Array((boxes.map(box => box.x + box.xo).reduce((a, b) => Math.max(a, b)) + 1)).fill(0).map(y => new Array((boxes.map(box => box.y + box.yo).reduce((a, b) => Math.max(a, b)) + 1))).map(y => y.fill(0));
	boxes.forEach(box => {
		for (let y = box.yo; y < box.yo + box.y; y++) {
			for (let x = box.xo; x < box.xo + box.x; x++) {
				myMap[y][x]++;
			}
		}
	});
	let count = 0;
	myMap.forEach(x => x.filter(y => y > 1).map(y => count++));
	return { map: myMap, boxes: boxes, count: count };
};

const partTwoShort = (obj) => {
	let correctbox = '';
	obj.boxes.forEach(box => {
		let isCorrect = true;
		for (let y = box.yo; (y < box.yo + box.y) && isCorrect && correctbox === ''; y++) {
			for (let x = box.xo; (x < box.xo + box.x) && isCorrect && correctbox === ''; x++) {
				if (obj.map[y][x] > 1) isCorrect = false;
				if (x === (box.xo + box.x - 1) && y === (box.yo + box.y - 1)) correctbox = box.id;
			}
		}
	});
	return correctbox;
};

let time = performance.now();
const resultPartOne = partOneShort(finSplit);
console.log(resultPartOne.count);
console.log('Part 1: ' + ((performance.now() - time) / 1000));
time = performance.now();
console.log(partTwoShort(resultPartOne));
console.log('Part 2: ' + ((performance.now() - time) / 1000));
