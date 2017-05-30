#!/usr/bin/php
<?php

if ($argv[1] == 'config') {
	$return = [
		'graph_title Mysql Replication',
		'graph_vlabel replication_status',
		'graph_category mysql',
		'graph_scale no',
		'graph_args -l 0',

		'replication_status.label Replication Status',
		'replication_status.warning 0.5:1',
	];
	echo implode("\n", $return);

	return;
}

$exec = "mysql --defaults-file=/etc/mysql/debian.cnf -e \"SHOW GLOBAL STATUS\"";
$output_raw = [];
$return = null;
$result = [
	'replication_status' => 0,
];
exec($exec, $output_raw, $return);

if ($return === 0) {
	$output = mysql_result_list_to_array($output_raw);
	$result['replication_status'] = ($output['Slave_running'] == 'ON') ? 1 : 0;
}

foreach ($result as $key => $value) {
	echo "{$key}.value {$value}\n";
}

function mysql_result_list_to_array($output_raw)
{
	/*
        [sample]
        wsrep_local_bf_aborts                                        0
        wsrep_local_index                                            18446744073709551615
	*/
	$output = [];
	foreach ($output_raw as $output_line) {
		if (preg_match('/([\w_]+)\s*([\w_]+)/', $output_line, $match)) {
			$key = $match[1];
			$value = $match[2];
			$output[$key] = $value;
		}
	}

	return $output;
}

