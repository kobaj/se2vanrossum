<?php
echo '<!DOCTYPE html><html><head></head><body>';

echo '<p>Welcome to the online ACL2 Powered create-board v.01</p>';

echo '<form method="get" action=""><textarea name="words">' . $_GET['words'] . '</textarea><br /><input type="submit" value="Submit"></form>';

run_setup();

function run_create_board()
{
	if (isset ($_GET['words']))
	{
		// clean things up
		$words = preg_split("/[\s,\-_\n]*/", $_GET['words']);
		foreach ($words as $key => $word)
			$words[$key] = trim($word);
		$implode_words = '"' . implode('" "', $words) . '"';

		// make our input file
		do_replacement($ACL2_SRC_DIR . $SETUP_TEMPLATE, $ACL2_SRC_DIR . $SETUP, $implode_words);

		//output the words
		echo '<ul>';
		foreach ($words as $word)
			echo '<li>' . $word . '</li>';
		echo '</ul>';

		// run command
		// NOTE for now this uses redirected input, but it will eventually
		// use clay's ACL2 code
		$final_call = $ACL2_EXE_DIR . ' < ' . $ACL2_SRC_DIR . $ACL2_COMMAND . $SETUP . '.txt';
		echo '<p>' . $final_call . '</p>';
		exec($final_call, $return);
		echo '<p>';
		$output = false;
		foreach ($return as $key => $results)
		{
			if (stristr($results, 'Iprinting has been enabled'))
				- $output = true;

			if ($output)
				echo $results . '<br />';
		}
		echo '</p>';

	}
}

function do_replacement($file_in, $file_out, $words)
{
	$data = file_get_contents($file_in . '.txt');

	// do tag replacements or whatever you want
	$data = str_replace('{WORDS}', $words, $data);

	//save it back:
	file_put_contents($file_out . '.txt', $data);
}

function run_setup()
{
	$running_local = false;
	if ($_SERVER['REMOTE_ADDR'] == '::1')
		$running_local = true;

	if ($running_local)
	{
		if (isset ($_COOKIE['ACL2_EXE_DIR']) && isset ($_COOKIE['ACL2_SRC_DIR']))\
		{
			if (file_exists($_COOKIE['ACL2_EXE_DIR']) && is_dir($_COOKIE['ACL2_SRC_DIR']))
			{
				//run with our commands
			}
			else
			{

			}
		}
		elseif (isset ($_POST['ACL2_EXE_DIR']) && isset ($_POST['ACL2_SRC_DIR']))\
		{

		}
		else
		{

		}
	}
	else
	{
		// not running local, use preset directories
		$ACL2_EXE_DIR = 'C:/ACL2_x64/run_acl2.exe';
		$ACL2_SRC_DIR = 'C:/Users/Jakob/Desktop/School/Spring2013/se/svn/src/';

		set_directories($ACL2_EXE_DIR, $ACL2_SRC_DIR);
	}

	setcookie("user", "Alex Porter", time() + 3600);
}

function set_directories($ACL2_EXE_DIR, $ACL2_SRC_DIR, $SETUP_TEMPLATE = 'setup/setup', $SETUP = 'setup/setup_final')
{
	define('ACL2_EXE_DIR'		 , $ACL2_EXE_DIR);
	define('ACL2_SRC_DIR'		 , $ACL2_SRC_DIR);
	define('SETUP_TEMPLATE'		 , $SETUP_TEMPLATE);
	define('SETUP'		 		 , $SETUP);
}

echo '</body></html>';