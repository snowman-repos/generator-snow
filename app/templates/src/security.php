<?php

	require_once("utils.php");

	$data = array();

	$data["CSRFName"] = "CSRFGuard_".mt_rand(0, mt_getrandmax());
	$data["CSRFToken"] = csrfguard_generate_token($data["CSRFName"]);

	echo json_encode($data);

?>