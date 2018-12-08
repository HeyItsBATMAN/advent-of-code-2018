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

// Part one, small
const partOne = (array) => {
	const guards = [];
	let guardIndex = 0;
	array.map(line => ({ timestamp: new Date(line.split(']')[0].substr(1)).getTime(), minutes: new Date(line.split(']')[0].substr(1)).getMinutes(), data: line.split(']')[1] }))
		.sort((a, b) => a.timestamp - b.timestamp)
		.forEach((obj, index, arr) => {
			if (obj.data.indexOf('begins shift') !== -1) {
				const guard_id = obj.data.split('#')[1].split(' ')[0];
				const filter = guards.filter(guard => guard.id === guard_id);
				if (filter.length > 0) {
					// Old guard
					guardIndex = guards.findIndex((v) => v.id === filter[0].id);
				} else {
					// New guard
					guards.push({
						id: guard_id,
						total: 0,
						minutes: new Array(60).fill(0)
					});
					guardIndex = guards.length - 1;
				}
			} else if (obj.data.indexOf('wakes up') !== -1) {
				guards[guardIndex].total += arr[index].timestamp - arr[index - 1].timestamp;
				for (let minute = arr[index - 1].minutes; minute < arr[index].minutes; minute++) {
					guards[guardIndex].minutes[minute]++;
				}
			}
		});

	guards.sort((a, b) => b.total - a.total);
	return ({ guards: guards, result: { id: guards[0].id, minute: guards[0].minutes.indexOf(Math.max(...guards[0].minutes)) } });
};

// Part one, performance optimized
const partOnePerf = (array) => {
	const guards = [];
	const arrLen = array.length;
	for (let i = arrLen - 1; i >= 0; i--) {
		const indexOfClosing = array[i].indexOf(']');
		const lsplit = array[i].substring(1, indexOfClosing);
		const rsplit = array[i].substring(indexOfClosing + 1);
		const datetime = new Date(lsplit);
		array[i] = (({ timestamp: datetime.getTime(), minutes: datetime.getMinutes(), data: rsplit }));
	}
	array = array.sort((a, b) => a.timestamp - b.timestamp);
	let guardIndex = 0;
	for (let index = 0; index < array.length; index++) {
		const obj = array[index];
		if (obj.data.indexOf('begins shift') !== -1) {
			const hashIndex = obj.data.indexOf('#') + 1;
			const guard_id = obj.data.substring(hashIndex, obj.data.indexOf(' ', hashIndex));
			const filterRes = [];
			const gArrLen = guards.length;
			let gResIndex = 0;
			for (let i = 0; i < gArrLen; i++) {
				if (guards[i].id === guard_id) {
					filterRes.push(guards[i]);
					gResIndex = i;
					break;
				}
			}
			if (filterRes.length > 0) {
				// Old guard
				guardIndex = gResIndex;
			} else {
				// New guard
				guards.push({
					id: guard_id,
					total: 0,
					minutes: new Array(60).fill(0)
				});
				guardIndex = guards.length - 1;
			}
		} else if (obj.data.indexOf('wakes up') !== -1) {
			guards[guardIndex].total += array[index].timestamp - array[index - 1].timestamp;
			for (let minute = array[index - 1].minutes; minute < array[index].minutes; minute++) {
				guards[guardIndex].minutes[minute]++;
			}
		}
	}
	guards.sort((a, b) => b.total - a.total);
	return ({ guards: guards, result: { id: guards[0].id, minute: guards[0].minutes.indexOf(Math.max(...guards[0].minutes)) } });
};

// Part two
const partTwo = (array) => {
	array.sort((b, a) => a.minutes.reduce((aa, ab) => Math.max(aa, ab)) -
		b.minutes.reduce((ba, bb) => Math.max(ba, bb)));
	return ({ id: array[0].id, minute: array[0].minutes.indexOf(Math.max(...array[0].minutes)) });
};

// Running and Benchmarking
time1 = process.hrtime();
const partOneResult = partOnePerf([...finSplit]);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 1:\t' + printTime(restime));
console.log(parseInt(partOneResult.result.id, 10) * partOneResult.result.minute);
time1 = process.hrtime();
const partTwoResult = partTwo(partOneResult.guards);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2:\t' + printTime(restime));
console.log(parseInt(partTwoResult.id, 10) * partTwoResult.minute);
