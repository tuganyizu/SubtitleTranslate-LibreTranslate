/*
	real time subtitle translate for PotPlayer using LibreTranslate API
*/

// string GetTitle() 														-> get title for UI
// string GetVersion														-> get version for manage
// string GetDesc()															-> get detail information
// string GetLoginTitle()													-> get title for login dialog
// string GetLoginDesc()													-> get desc for login dialog
// string ServerLogin(string User, string Pass)								-> login
// string ServerLogout()													-> logout
// array<string> GetSrcLangs() 												-> get source language
// array<string> GetDstLangs() 												-> get target language
// string Translate(string Text, string &in SrcLang, string &in DstLang) 	-> do translate !!

string JsonParse(string json)
{
	JsonReader Reader;
	JsonValue Root;
	string ret = "";
	
	if (Reader.parse(json, Root) && Root.isObject())
	{
		JsonValue translatedText = Root["translatedText"];
		if (translatedText.isString()) ret = ret + translatedText.asString();
	} 
	return ret;
}

array<string> LangTable = 
{
"ar",
"az",
"bg",
"bn",
"ca",
"cs",
"da",
"de",
"el",
"en",
"eo",
"es",
"et",
"fa",
"fi",
"fr",
"ga",
"he",
"hi",
"hu",
"id",
"it",
"ja",
"ko",
"lt",
"lv",
"ms",
"nb",
"nl",
"pl",
"pt",
"ro",
"ru",
"sk",
"sl",
"sq",
"sv",
"th",
"tl",
"tr",
"uk",
"zh",
"zt"
};

string UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36";
string TranslateHost = "libretranslate.com";

string GetTitle()
{
	return "{$CP949=LibreTranslate 번역$}{$CP950=LibreTranslate 翻譯$}{$CP0=LibreTranslate$}";
}

string GetVersion()
{
	return "1";
}

string GetDesc()
{
	return "A LibreTranslate Server";
}

string GetLoginTitle()
{
	return "Input LibreTranslate API key";
}

string GetLoginDesc()
{
	return "Input LibreTranslate API key to user name";
}

string api_key;

string ServerLogin(string User, string Pass)
{
	api_key = User;
	if (api_key.empty()) return "fail";
	return "200 ok";
}

void ServerLogout()
{
	api_key = "";
}

array<string> GetSrcLangs()
{
	array<string> ret = LangTable;
	
	ret.insertAt(0, ""); // empty is auto
	return ret;
}

array<string> GetDstLangs()
{
	array<string> ret = LangTable;
	
	return ret;
}

string Translate(string Text, string &in SrcLang, string &in DstLang)
{
	// HostOpenConsole();	// for debug

	if (SrcLang.length() <= 0) SrcLang = "auto";
	if (!DstLang.empty() && DstLang == "zh-CN") DstLang = "zh";
	SrcLang.MakeLower();
	
	string rpc_url = "https://libretranslate.com/translate";

	string post_data_prefix = "{\"q\": \"";
	string post_data_suffix = "\",\"source\":\""+SrcLang+"\",\"target\":\""+DstLang+"\",\"format\":\"text\",\"api_key\":\""+api_key+"\"}";
	Text.replace("\\","\\");
	Text.replace("\"","\"");
	Text.replace("\\","\\");
	Text.replace("\"","\"");
	Text.replace("\n","\\\\n");
	Text.replace("\r","\\\\r");
	Text.replace("\t","\\\\t");
	string enc_text = Text;
	string post_data_json = post_data_prefix + enc_text + post_data_suffix;

	string SendHeader = "Content-Type: application/json";
	
	string text = HostUrlGetString(rpc_url, UserAgent, SendHeader, post_data_json);
	string ret = JsonParse(text);
	if (ret.length() > 0)
	{
		SrcLang = "UTF8";
		DstLang = "UTF8";
		return ret;
	}	

	return ret;
}
