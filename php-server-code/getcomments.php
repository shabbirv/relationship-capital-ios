<?php

require_once('engine.php');
header("Content-Type:application/json");

$engine = new RCEngine();

$commitment_id = $_GET['commitment_id'];

$engine->get_comments($commitment_id)

?>