// content.js.

// Global variables.

var body_editor = null;
var head_editor = null;

var generate_content_callback =
{
	success: function(o)
	{
		if (o.responseText !== undefined)
		{
			var data = YAHOO.lang.JSON.parse(o.responseText);
			var div  = data.results.target_div;
			var e    = document.getElementById(div);
			e.innerHTML = data.results.message;
		}
		else
		{
			var e = document.getElementById("update_content_message_div");
			e.innerHTML = "The server's response is incomprehensible";
		};
	},
	failure: function(o)
	{
		var e = document.getElementById("update_content_message_div");
		e.innerHTML = "The server failed to respond";
	}
};

var update_content_callback =
{
	success: function(o)
	{
		if (o.responseText !== undefined)
		{
			var data = YAHOO.lang.JSON.parse(o.responseText);
			var div  = data.results.target_div;
			var e    = document.getElementById(div);
			e.innerHTML = data.results.message;

			if (div == "update_page_message_div")
			{
				// An error was just displayed.
			}
			else
			{
				e = document.getElementById("update_content_homepage_div");
				e.innerHTML = data.results.homepage;

				if (body_editor === null)
				{
					body_editor = new YAHOO.widget.Editor
					(
					'body',
					{
						height:  '<: $editor_body_window_height :>',
						width:   '<: $editor_body_window_width :>',
						dompath: true
					});
				}

				if (head_editor === null)
				{
					head_editor = new YAHOO.widget.Editor
					(
					'head',
					{
						height:  '<: $editor_head_window_height :>',
						width:   '<: $editor_head_window_width :>',
						dompath: true
					});
				}

				body_editor.render();
				head_editor.render();

				tab_view.set('activeIndex', 3); // Edit Contents tab.
				make_update_content_name_focus();
			}
		}
		else
		{
			var e = document.getElementById("update_page_message_div");
			e.innerHTML = "The server's response is incomprehensible";
		};
	},
	failure: function(o)
	{
		var e = document.getElementById("update_page_message_div");
		e.innerHTML = "The server failed to respond";
	}
};

var update_content_onsubmit = function ()
{
	if (FIC_checkForm("update_content_form") == false)
	{
		return false;
	}

	var action = document.update_content_form.action.value;
	var url    = "<: $form_action :>/content/";

	switch (action)
	{
	case "1":
		url = url + "update";
		break;

	case "2":
		url = url + "backup";
		break;

	case "3":
		url = url + "generate";
		break;
	}

	var p = YAHOO.util.Connect.setForm("update_content_form");

	if (action == 1)
	{
		body_editor.saveHTML();
		head_editor.saveHTML();
		var body = body_editor.get('element').value;
		var head = head_editor.get('element').value;
		alert('Head: <' + head + '>');
		var r = YAHOO.util.Connect.asyncRequest("POST", url, update_content_callback);
	}
	else
	{
		var r = YAHOO.util.Connect.asyncRequest("POST", url, generate_content_callback);
	}

	document.update_content_form.action.value = 0; // Reset for next time!

	return false;
}
