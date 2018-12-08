import { readFileSync, existsSync } from 'fs';
import { basename } from 'path';
import { performance } from 'perf_hooks';
const inFile = basename(__filename, '.ts');
if (!existsSync(`./${inFile}.txt`)) {
	console.log('File not loaded... Exiting');
	process.exit(0);
}
const finSplit = readFileSync(`./${inFile}.txt`).toString().split(' ').map(v => parseInt(v, 10));
console.log('File imported');
const exSplit = `2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2`.split(' ');

// Part one
const partOne = (input) => {
	const nodes = [];
	const resolveNode = (i, n, m) => {
		const header = [n[i], n[i + 1]];
		const node = {header: [...header], children: [], metadata: []};
		i += 2;
		for (let j = 0; j < header[0]; j++) {
			const res = resolveNode(i, n, m);
			i = res.index;
			node.children.push(res.node);
		}
		for (let j = 0; j < header[1]; j++) {
			node.metadata.push(n[i]);
			i++;
		}
		nodes.push(node);
		return { index: i, node: node };
	};
	resolveNode(0, input, nodes);
	return { result: nodes.reduce((a, b) => a += b.metadata.reduce((c, d) => c += d, 0), 0), data: nodes };
};

// Part two
const partTwo = (obj) => {
	const loopMeta = (child) => {
		let val = 0;
		for (let i = 0; i < child.metadata.length; i++) {
			const newChild = child.children[child.metadata[i] - 1];
			val += newChild ? getChildValue(newChild) : 0;
		}
		return val;
	};
	const getChildValue = (child) => {
		return (child.header[0] === 0) ? child.metadata.reduce((a, b) => a += b, 0) : loopMeta(child);
	};
	return { result: loopMeta(obj.data[obj.data.length - 1]) };
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
const partTwoResult = partTwo(partOneResult);
time2 = process.hrtime();
restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Part 2: ' + printTime(restime));
console.log(partTwoResult.result);
