import { readdirSync } from 'fs';
import { printTime } from './printtime';

const filelist = [];
readdirSync('src/').forEach(file => {
	if (file.substring(0, 3) === 'aoc' && !file.includes('.map') && Number(file.substring(3, file.indexOf('.'))).toString() !== 'NaN') {
		filelist.push(file);
	}
});

// Splitted into another loop so the if statements in the above loop can't possibly bottleneck
const time1 = process.hrtime();
for (let i = 0; i < filelist.length; i++) {
	console.log('AoC:\t' + filelist[i]);
	require('./' + filelist[i]);
}
const time2 = process.hrtime();
const restime = (time2[0] * 1000000 + time2[1] / 1000) - (time1[0] * 1000000 + time1[1] / 1000);
console.log('Total:\t' + printTime(restime));
