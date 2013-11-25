<?php

require_once('engine.php');
header("Content-Type:application/json");

$engine = new RCEngine();

$comment = $_POST['text'];
$user_id = $_POST['user_id'];
$commitment_id = $_POST['commitment_id'];

$engine->add_comment($comment, $user_id, $commitment_id)

?>