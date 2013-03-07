<?php

echo '<!DOCTYPE html><html><head></head><body>';


echo '<p>Welcome to the online ACL2 Powered create-board v.01</p>';

echo '<form method="get" action=""><textarea name="words">comma,separated,words</textarea><br /><input type="submit" value="Submit"></form>';

if(isset($_GET['words']))
{
	// associated directories
	$ACL2_EXE_DIR = 'C:/ACL2_x64/run_acl2.exe';
	$ACL2_SRC_DIR = 'C:/Users/Jakob/Desktop/School/Spring2013/se/svn/src/';

	$SETUP_TEMPLATE = 'setup/setup';
	$SETUP			= 'setup/setup_final';

	// clean things up
	$words = explode(',', $_GET['words']);
	foreach($words as $key => $word)
		$words[$key] = trim($word);
	$words = '"' . implode('" "', $words) . '"';

	// make our input file
	do_replacement($ACL2_SRC_DIR . $SETUP_TEMPLATE,
				   $ACL2_SRC_DIR . $SETUP,
				   $words);

	// run command
	// NOTE for now this uses redirected input, but it will eventually
	// use clay's ACL2 code
	$final_call = $ACL2_EXE_DIR . ' < ' . $ACL2_SRC_DIR . $ACL2_COMMAND . $SETUP . '.txt';
	echo '<p>' . $final_call . '</p>';
	exec($final_call, $return);
	echo '<p>';
	$output = false;
	foreach($return as $key => $results)
	{
		if(stristr($results, 'Iprinting has been enabled'))
			$output = true;

		if($output)
			echo $results . '<br />';
	}
	echo '</p>';

}

function do_replacement($file_in, $file_out, $words)
{
	$data = file_get_contents($file_in . '.txt');

	// do tag replacements or whatever you want
	$data = str_replace('{WORDS}', $words, $data);

	//save it back:
	file_put_contents($file_out . '.txt', $data);
}

echo '</body></html>';