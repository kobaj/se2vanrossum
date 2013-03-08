<?php
echo '<!DOCTYPE html><html><head></head><body>';

echo '<p>Welcome to the online ACL2 Powered create-board v.01</p>';

echo '<form method="get" action=""><textarea name="words">' . (isset($_GET['words']) ? $_GET['words'] : 'Put your words here.') . '</textarea><br /><input type="submit" value="Submit"></form>';

if (run_setup())
	run_create_board();

function run_create_board()
{
	if (isset ($_GET['words']))
	{
		// clean things up
		$words = preg_split("/[\s,\-_\n]+/", $_GET['words']);
		foreach ($words as $key => $word)
		{
			$temp_word = trim($word);
			if(!empty($temp_word))
				$words[$key] = $temp_word;
			else
				unset($words[$key]);
		}
		$implode_words = '"' . implode('" "', $words) . '"';

		// make our input file
		$SETUP = do_replacement(ACL2_SRC_DIR . SETUP_TEMPLATE, $implode_words);

		//output the words
		echo '<ul>';
		foreach ($words as $word)
			echo '<li>' . $word . '</li>';
		echo '</ul>';

		// run command
		// NOTE for now this uses redirected input, but it will eventually
		// use clay's ACL2 code
		$final_call = ACL2_EXE_DIR . ' < ' . $SETUP;
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

		//delete setup
		//unlink($SETUP);
	}
}

function do_replacement($file_in, $words)
{
	$data = file_get_contents($file_in . '.txt');

	// do tag replacements or whatever you want
	$data = str_replace('{WORDS}', $words, $data);
	$data = str_replace('{ACL2_SRC_DIR}', ACL2_SRC_DIR, $data);
	$data = str_replace('{ACL2_TEACHPACKS}', ACL2_TEACHPACKS, $data); 

	//make a temp file
	$tmpfname = tempnam(sys_get_temp_dir(), 'acl');

	$handle = fopen($tmpfname, "w");
	fwrite($handle, $data);
	fclose($handle);

	return $tmpfname;
}

function run_setup()
{
	$running_local = false;
	if ($_SERVER['REMOTE_ADDR'] == '::1')
		$running_local = true;

	if ($running_local)
	{
		if (isset ($_COOKIE['ACL2_EXE_DIR']) && isset ($_COOKIE['ACL2_SRC_DIR']) && isset ($_COOKIE['ACL2_TEACHPACKS']))
		{
			if (file_exists($_COOKIE['ACL2_EXE_DIR']) && is_dir($_COOKIE['ACL2_SRC_DIR']) && is_dir($_COOKIE['ACL2_TEACHPACKS']))
			{
				//run with our commands
				set_directories($_COOKIE['ACL2_EXE_DIR'], $_COOKIE['ACL2_SRC_DIR'], $_COOKIE['ACL2_TEACHPACKS']);
				return true;
			}
			else
			{
				echo '<p>Problem with directories, try again.</p>';
				unset_directories();
			}
		}
		elseif (isset ($_POST['ACL2_EXE_DIR']) && isset ($_POST['ACL2_SRC_DIR']) && isset ($_POST['ACL2_TEACHPACKS']))
		{
			if (file_exists($_POST['ACL2_EXE_DIR']) && is_dir($_POST['ACL2_SRC_DIR']) && is_dir($_POST['ACL2_TEACHPACKS']))
			{
				//run with our commands
				set_directories($_POST['ACL2_EXE_DIR'], $_POST['ACL2_SRC_DIR'], $_POST['ACL2_TEACHPACKS']);
				return true;
			}
			else
			{
				echo '<p>Problem with directories, try again.</p>';
				unset_directories();
			}
		}

		//print a form to enter stuffs
		echo '<form method="post" action="">';
		echo '<span class="label">ACL2 EXE Directory</span><input type="text" name="ACL2_EXE_DIR" />';
		echo '<span class="label">ACL2 SRC Directory</span><input type="text" name="ACL2_SRC_DIR" />';
		echo '<span class="label">ACL2 Teachpacks</span><input type="text" name="ACL2_TEACHPACKS" />';
		echo '<input type="submit" value="Submit"></form>';

	}
	else
	{
		// not running local, use preset directories
		$ACL2_EXE_DIR = 'C:/ACL2/run_acl2.exe';
		$ACL2_SRC_DIR = 'C:/Users/Jakob/Desktop/School/Spring2013/se/svn/src/';
		$ACL2_TEACHPACKS = 'C:/Users/Jakob/AppData/Roaming/Racket/planet/300/5.2.1/cache/cce/dracula.plt/8/23/teachpacks';

		set_directories($ACL2_EXE_DIR, $ACL2_SRC_DIR, $ACL2_TEACHPACKS);
		return true;
	}

	return false;
}

function set_directories($ACL2_EXE_DIR, $ACL2_SRC_DIR, $ACL2_TEACHPACKS, $SETUP_TEMPLATE = 'setup/setup')
{
	define('ACL2_EXE_DIR', $ACL2_EXE_DIR);
	define('ACL2_SRC_DIR', $ACL2_SRC_DIR);
	define('SETUP_TEMPLATE', $SETUP_TEMPLATE);
	define('ACL2_TEACHPACKS', $ACL2_TEACHPACKS);

	setcookie("user", "Alex Porter", time() + 3600);
	setcookie("user", "Alex Porter", time() + 3600);
	setcookie("user", "Alex Porter", time() + 3600);
}

function unset_directories()
{
	setcookie("user", "Alex Porter", time() - 3600);
	setcookie("user", "Alex Porter", time() - 3600);
	setcookie("user", "Alex Porter", time() - 3600);
}

echo '</body></html>';