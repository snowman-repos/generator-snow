<?php

	// CHANGE THESE VALUES
	$appid = "67170";
	$brandid = "30";
	$promocode = "promocode";

	require_once("neo/NEO-interface-1.3.php");
	require_once("utils.php");

	$neo = new NEOinterface13();

	$result = array();

	if(csrfguard_validate_token($_POST["CSRFName"], $_POST["CSRFToken"])) {		

		$data = array();

		foreach ($_POST as $key => $value ) {

			$data[$key] = htmlspecialchars($value);

		}

		$data["dob"] = $data["year"]."-".$data["month"]."-".$data["day"];

		$country_optID = array(
			"AD" => 1,"AE" => 2,"AF" => 3,"AG" => 4,"AI" => 5,"AL" => 6,"AM" => 7,"AN" => 8,"AO" => 9,"AQ" => 10,
			"AR" => 11,"AS" => 12,"AT" => 13,"AU" => 14,"AW" => 15,"AZ" => 16,"BA" => 17,"BB" => 18,"BD" => 19,"BE" => 20,
			"BF" => 21,"BG" => 22,"BH" => 23,"BI" => 24,"BJ" => 25,"BM" => 26,"BN" => 27,"BO" => 28,"BR" => 29,"BS" => 30,
			"BT" => 31,"BV" => 32,"BW" => 33,"BY" => 34,"BZ" => 35,"CA" => 36,"CC" => 37,"CF" => 38,"CG" => 39,"CH" => 40,
			"CI" => 41,"CK" => 42,"CL" => 43,"CM" => 44,"CN" => 45,"CO" => 46,"CR" => 47,"CS" => 48,"CU" => 49,"CV" => 50,
			"CX" => 51,"CY" => 52,"CZ" => 53,"DE" => 54,"DJ" => 55,"DK" => 56,"DM" => 57,"DO" => 58,"DZ" => 59,"EC" => 60,
			"EE" => 61,"EG" => 62,"EH" => 63,"ER" => 64,"ES" => 65,"ET" => 66,"FI" => 67,"FJ" => 68,"FK" => 69,"FM" => 70,
			"FO" => 71,"FR" => 72,"FX" => 73,"GA" => 74,"GB" => 75,"GD" => 76,"GE" => 77,"GF" => 78,"GH" => 79,"GI" => 80,
			"GL" => 81,"GM" => 82,"GN" => 83,"GP" => 84,"GQ" => 85,"GR" => 86,"GS" => 87,"GT" => 88,"GU" => 89,"GW" => 90,
			"GY" => 91,"HK" => 92,"HM" => 93,"HN" => 94,"HR" => 95,"HT" => 96,"HU" => 97,"ID" => 98,"IE" => 99,"IL" => 100,
			"IN" => 101,"IO" => 102,"IQ" => 103,"IR" => 104,"IS" => 105,"IT" => 106,"JM" => 107,"JO" => 108,"JP" => 109,"KE" => 110,
			"KG" => 111,"KH" => 112,"KI" => 113,"KM" => 114,"KN" => 115,"KR" => 116,"KW" => 117,"KY" => 118,"KZ" => 119,"LA" => 120,
			"LB" => 121,"LC" => 122,"LI" => 123,"LK" => 124,"LR" => 125,"LS" => 126,"LT" => 127,"LU" => 128,"LV" => 129,"LY" => 130,
			"MA" => 131,"MC" => 132,"MD" => 133,"MG" => 134,"MH" => 135,"MK" => 136,"ML" => 137,"MM" => 138,"MN" => 139,"MO" => 140,
			"MP" => 141,"MQ" => 142,"MR" => 143,"MS" => 144,"MT" => 145,"MU" => 146,"MV" => 147,"MW" => 148,"MX" => 149,"MY" => 150,
			"MZ" => 151,"NA" => 152,"NC" => 153,"NE" => 154,"NF" => 155,"NG" => 156,"NI" => 157,"NL" => 158,"NO" => 159,"NP" => 160,
			"NR" => 161,"NU" => 162,"NZ" => 163,"OM" => 164,"PA" => 165,"PE" => 166,"PF" => 167,"PG" => 168,"PH" => 169,"PK" => 170,
			"PL" => 171,"PM" => 172,"PN" => 173,"PR" => 174,"PT" => 175,"PW" => 176,"PY" => 177,"QA" => 178,"RE" => 179,"RO" => 180,
			"RU" => 181,"RW" => 182,"SA" => 183,"SB" => 184,"SC" => 185,"SD" => 186,"SE" => 187,"SG" => 188,"SH" => 189,"SI" => 190,
			"SJ" => 191,"SK" => 192,"SL" => 193,"SM" => 194,"SN" => 195,"SO" => 196,"SR" => 197,"ST" => 198,"SU" => 199,"SV" => 200,
			"SY" => 201,"SZ" => 202,"TC" => 203,"TD" => 204,"TF" => 205,"TG" => 206,"TH" => 207,"TJ" => 208,"TK" => 209,"TM" => 210,
			"TN" => 211,"TO" => 212,"TP" => 213,"TR" => 214,"TT" => 215,"TV" => 216,"TW" => 217,"TZ" => 218,"UA" => 219,"UG" => 220,
			"UM" => 221,"US" => 222,"UY" => 223,"UZ" => 224,"VA" => 225,"VC" => 226,"VE" => 227,"VG" => 228,"VI" => 229,"VN" => 230,
			"VU" => 231,"WF" => 232,"WS" => 233,"YE" => 234,"YT" => 235,"YU" => 236,"ZA" => 237,"ZM" => 238,"ZR" => 239,"ZW" => 240,
			"KR" => 241,"RS" => 242,"AX" => 243,"CD" => 244,"GG" => 245,"IM" => 246,"JE" => 247,"ME" => 248,"PS" => 249,"BL" => 250,
			"MF" => 251,"TL" => 252,"ZZ" => 253);

		if($data["country"])
			$data["countryID"] = $country_optID[$data["country"]];

		$data["acquisitionsource"] = "<%= _.slugify(sitename) %>";

		$result = $neo->userRegister($data, $appid, $brandid, $promocode);

	} else {

		$result = array("error" => "failed CSRF");

	}

	echo json_encode($result);

?>