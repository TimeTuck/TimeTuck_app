<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Main extends CI_Controller {

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/Main.php/welcome
	 *	- or -
	 * 		http://example.com/Main.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /Main.php/welcome/<method_name>
	 * @see http://codeigniter.com/user_guide/general/urls.html
	 */
	public function index()
	{
		if (!array_key_exists('key', $_GET) || !array_key_exists('secret', $_GET))
			show_404();

		$this->load->database();
		$query = $this->db->query("call timecapsule_get_live_from_session(?, ?)", array($_GET['key'], $_GET['secret']));
		$resultArray = $query->result_array();
		$data = array('results' => $resultArray);
		$this->load->view('main_view', $data);
	}
}
