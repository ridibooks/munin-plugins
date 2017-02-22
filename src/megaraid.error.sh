#!/usr/bin/php
<?php

if($argv[1] == 'config')
{
	$return = [
		'graph_title Megaraid Error',
		'graph_vlabel topology_error vd_error pd_error',
		'graph_category disk',
		'graph_scale no',
		'graph_args -l 0',

		'topology_error.label Topology Error',
		'vd_error.label Virtual Disk Error',
		'pd_error.label Physical Disk Error',

		'topology_error.warning 0.5',
		'vd_error.warning 0.5',
		'pd_error.warning 0.5',
	];
	echo implode("\n", $return);
	return;
}

if (is_file('/opt/MegaRAID/storcli/storcli64')) {
	$megaraid = shell_exec('/opt/MegaRAID/storcli/storcli64 /c0 show');

	$disk_states = getStateByMenuForMegaraid($megaraid, 'TOPOLOGY', 7);
	$result['topology_error'] = $disk_states;

	$disk_states = getStateByMenuForMegaraid($megaraid, 'VD LIST', 3);
	$result['vd_error'] = $disk_states;

	$disk_states = getStateByMenuForMegaraid($megaraid, 'PD LIST', 3);
	$result['pd_error'] = $disk_states;

	foreach($result as $key => $states)
	{
		$error_states = array_diff($states, ['Optl','Onln']);
		$error_count = count($error_states);
		echo "{$key}.value {$error_count}\n";
	}
}

function getStateByMenuForMegaraid($string, $key, $state_index)
{
	/**
	 * PD LIST :
	 * =======
	 *
	 * ---------------------------------------------------------------------------
	 * EID:Slt DID State DG     Size Intf Med SED PI SeSz Model                Sp
	 * ---------------------------------------------------------------------------
	 * 252:0     1 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:1     3 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:2     2 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:3     0 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:4     6 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:5     7 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:6     4 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * 252:7     5 Onln   0 3.637 TB SATA HDD N   N  512B HGST HDN724040ALE640 U
	 * ---------------------------------------------------------------------------
	 */
	$states = array();
	if (preg_match('/' . $key . '.+^-+.+^-+$(.+)^-+/Usm', $string, $match)) {
		$disks = trim($match[1]);
		$regex = str_repeat("(\S+)\s+", $state_index);
		if (preg_match_all("/^\s*" . $regex . "/m", $disks, $match)) {
			$states = $match[$state_index];
		}
	}
	return $states;
}
