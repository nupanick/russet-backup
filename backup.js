#!/usr/bin/env nodejs

const { execSync: sh } = require('child_process')

function run(...args) {
	const command = args.join(' ');
	console.log(command);
	if (process.env.DRY_RUN === 'false') {
		sh(command, { stdio: 'inherit' });
	}
}

const BACKUP = '/mnt/backup';
const DATA = '/mnt/data';

const today = sh('date -u +"%Y-%m-%dT%H-%M-%SZ"').toString();
const new_data = `data_${today}`;
const old_data = sh(`ls ${BACKUP} | grep ^data | tail -1`).toString();

run('rsync -a --link-dest',
	`${BACKUP}/${old_data}`,
	`${DATA}`,
	`${BACKUP}/${new_data}`,
);
