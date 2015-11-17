set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.2.00.07'
,p_default_workspace_id=>13707805413010735447
,p_default_application_id=>52892
,p_default_owner=>'JOSEPCOVES'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/es_relational_josepcoves_datehourpicker
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(67059297306859688506)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'ES.RELATIONAL.JOSEPCOVES.DATEHOURPICKER'
,p_display_name=>'Relational: Date and hour picker'
,p_category=>'COMPONENT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'  function render_item (',
'    p_item                in apex_plugin.t_page_item,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_value               in varchar2,',
'    p_is_readonly         in boolean,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_page_item_render_result ',
'   AS  ',
'   ',
'    v_result apex_plugin.t_page_item_render_result; ',
'    v_page_item_name varchar2(100);',
'    ',
'    v_jquery_library_path varchar2(2000):= ''libraries/apex/minified/''; --Review this at APEX > 4.1',
'                                      --    libraries/jquery-ui/1.8.14/ui/i18n/oracle/ --4.1',
'',
'    --Plugin attributes:',
'    v_timestamp_format p_item.attribute_01%type := nvl(p_item.attribute_01,''HH24:MI'');',
'    v_timestamp_default_value p_item.attribute_02%type := apex_plugin_util.get_plsql_expression_result (p_plsql_expression => p_item.attribute_02);',
'    v_date_format p_item.attribute_03%type := nvl(p_item.attribute_03,''DD/MM/YYYY'');',
'    v_date_default_value p_item.attribute_04%type := apex_plugin_util.get_plsql_expression_result (p_plsql_expression => p_item.attribute_04);',
'    v_timestamp_lov p_item.attribute_05%type := p_item.attribute_05;',
'    v_timestamp_attributes p_item.attribute_06%type := p_item.attribute_06;',
'    v_datepicker_attributes p_item.attribute_07%type := p_item.attribute_07;',
'',
'    v_timestamp_lov_sql apex_application_lovs.list_of_values_query%type;',
'    v_display varchar2(4000);',
'    v_return varchar2(4000);',
'    type t_cur IS REF CURSOR;',
'    c1 t_cur;',
'',
'    v_html varchar2(9000);',
'    v_oracle_format p_item.format_mask%type; ',
'    v_js_format p_item.format_mask%type; ',
'    v_js_date_format  p_item.format_mask%type; ',
'    v_js_timestamp_format  p_item.format_mask%type; ',
'    v_app_id varchar2(100) := v(''APP_ID'');',
'    v_primary_language varchar2(100);',
'',
'    v_full_date_value date;',
'    v_full_date_string_value varchar2(200);',
'',
'    v_timestamp_value varchar2(100);',
'    v_full_timestamp varchar2(100);',
'    v_date_string_value varchar2(100);',
'    v_item_value varchar2(100);',
'    v_js_default_date varchar2(1000);',
'  BEGIN',
'    ',
'    IF apex_application.g_debug THEN',
'      apex_plugin_util.debug_page_item (p_plugin                => p_plugin,',
'                                        p_page_item             => p_item,',
'                                        p_value                 => p_value,',
'                                        p_is_readonly           => p_is_readonly,',
'                                        p_is_printer_friendly   => p_is_printer_friendly);',
'    END IF;',
'    ',
'    ',
'    IF p_is_readonly OR p_is_printer_friendly THEN    ',
'      apex_plugin_util.print_hidden_if_readonly (p_item_name             => p_item.name,',
'                                                 p_value                 => p_value,',
'                                                 p_is_readonly           => p_is_readonly,',
'                                                 p_is_printer_friendly   => p_is_printer_friendly);',
'      apex_plugin_util.print_display_only (p_item_name          => p_item.NAME,',
'                                           p_display_value      => p_value,',
'                                           p_show_line_breaks   => FALSE,',
'                                           p_escape             => TRUE,',
'                                           p_attributes         => p_item.element_attributes);',
'    ELSE',
'      ',
'      /********* Retreiving parameters and attributes **********/',
'      v_page_item_name := apex_plugin.get_input_name_for_page_item (p_is_multi_value => FALSE);',
'      ',
'      v_full_timestamp  := v_date_format||'' ''||v_timestamp_format;',
'',
'      v_oracle_format := nvl(v_full_timestamp, sys_context(''userenv'',''nls_date_format''));',
'      v_js_format := wwv_flow_utilities.get_javascript_date_format(p_format => v_oracle_format);',
'      v_js_date_format := wwv_flow_utilities.get_javascript_date_format(p_format => v_date_format);',
'      v_js_timestamp_format := wwv_flow_utilities.get_javascript_date_format(p_format => v_timestamp_format);',
'',
'      select application_primary_language ',
'        into v_primary_language',
'        from APEX_APPLICATIONS ',
'       where application_id = v_app_id;',
'      begin',
'        v_date_string_value := v_date_default_value;',
'        v_timestamp_value  := v_timestamp_default_value;',
'',
'        if (p_value is not null) then',
'          v_full_date_value := to_date(p_value,v_full_timestamp);',
'          v_timestamp_value := to_char(v_full_date_value,v_timestamp_format);',
'          v_date_string_value := to_char(v_full_date_value,v_date_format);',
'        else ',
'          v_full_date_value := sysdate; ',
'        end if; ',
'        v_item_value := nvl(p_value,v_date_string_value||'' ''||v_timestamp_value);',
'        v_js_default_date := to_char(v_full_date_value,''YYYY'')||'', ''||to_char(v_full_date_value,''MM'')||'', ''||to_char(v_full_date_value,''DD'')||'', ''||to_char(v_full_date_value,''HH24'')||'', ''||to_char(v_full_date_value,''MI'')||'', ''||to_char(v_full_date_va'
||'lue,''SS'');',
'      exception when others then',
'        v_item_value := p_value;',
'        v_full_date_value := null;',
'        v_timestamp_value := null;',
'        v_date_string_Value := null;',
'        v_js_default_date := to_char(sysdate,''YYYY'')||'', ''||to_char(sysdate,''MM'')||'', ''||to_char(sysdate,''DD'')||'', ''||to_char(sysdate,''HH24'')||'', ''||to_char(sysdate,''MI'')||'', ''||to_char(sysdate,''SS'');',
'      end;',
'      if (v_timestamp_lov is not null) then',
'        select list_of_values_query into v_timestamp_lov_sql ',
'          from apex_application_lovs ',
'         where application_id = v_app_id',
'               and list_of_values_name = v_timestamp_lov;',
'',
'      end if;',
'',
'      /* ********** Item rendering   ********* */',
'      --Display Hidden Item and Date Picker',
'      htp.p( ''<input type="hidden"',
'                        id="''||p_item.name||''" ',
'                        name="''||v_page_item_name||''" ',
'                        value="''||v_item_value ||''">  ',
'                 <input type="text" ',
'                        id="''||p_item.name||''_DATE" ',
'                        value="''||v_date_string_value ||''" ',
'                        autocomplete="off" ',
'                        size="''||p_item.element_width||''" ''||p_item.element_attributes||''>'');',
'',
'',
'      --Display Timestamp Field',
'      if (v_timestamp_lov_sql is not null) then',
'        htp.p(''<select id="''||p_item.name||''_HOUR" ''||v_timestamp_attributes ||'' style="vertical-align:top;margin-left:5px;">'');',
'',
'        open c1 for v_timestamp_lov_sql;',
'        loop ',
'        fetch c1 into v_display, v_return;',
'          exit when c1%notfound;',
'          htp.p(''<option value="''||v_return||''"''|| (case when v_return = v_timestamp_value then '' selected'' else '''' end)',
'                          ||''>''||v_display',
'                          ||''</option>'');',
'        end loop;          ',
'        close c1;',
'        htp.p(''</select>'');',
'      else',
'        htp.p(''<input type="text" ',
'                        id="''||p_item.name||''_HOUR" ',
'                        value="''||v_timestamp_value||''" ',
'                        autocomplete="off" ',
'                        value="''||v_timestamp_value ||''" ',
'                        size="''||length(v_timestamp_format)||''" ',
'                        style="vertical-align:top;margin-left:5px;" ''||v_timestamp_attributes||''>'');',
'      end if;',
'',
' ',
'      /****** JAVASCRIPT **************/',
'      v_html := ''',
'        (function () {',
'           apex.widget.datepicker("#''||p_item.name||''_DATE", {'';',
'',
'      --Allows user to introduce custom JS Datepicker Attributes',
'      if (v_datepicker_attributes is null) then',
'        v_html := v_html||',
'              ''"buttonImage": "''||:IMAGE_PREFIX||''asfdcldr.gif",',
'               "buttonImageOnly": true,',
'               "buttonText": "||p_item.label||",',
'               "showTime": false,',
'               "defaultDate": new Date(''||v_js_default_date||''),',
'               "showOn": "button",',
'               "showOtherMonths": false,',
'               "changeMonth": false,',
'               "changeYear": false'';',
'      else',
'        v_html := v_html|| v_datepicker_attributes;',
'      end if;',
'      v_html := v_html ||',
'           ''},',
'        "''||v_js_date_format ||''", ',
'        "''||v_primary_language||''");',
'        })();'';',
'      ',
'      v_html := v_html||',
'                ''$("#''||p_item.name||''_DATE").trigger(''''change'''');',
'                 $("#''||p_item.name||''_DATE").bind(''''change'''',',
'                    function(){                    ',
'                      $("#''||p_item.name||''").val($("#''||p_item.name||''_DATE").val()+'''' ''''+$("#''||p_item.name||''_HOUR").val());',
'                    }',
'                 );',
'                 $("#''||p_item.name||''_HOUR").trigger(''''change'''');',
'                 $("#''||p_item.name||''_HOUR").bind(''''change'''',',
'                    function(){                    ',
'                      $("#''||p_item.name||''").val($("#''||p_item.name||''_DATE").val()+'''' ''''+$("#''||p_item.name||''_HOUR").val());',
'                    }',
'                 );',
'',
'                ''; ',
'',
'      apex_javascript.add_library (p_name => ''jquery.ui.datepicker-en'', p_directory => p_plugin.file_prefix, p_version=> '''');',
'      /*apex_javascript.add_library (p_name => ''widget.datepicker.min'', p_directory => p_plugin.file_prefix, p_version=> '''');*/',
'',
'      apex_javascript.add_library(',
'            p_name       => ''widget.timepicker.min.js?v=4.2.5.00.08'',',
'            p_directory  => apex_application.g_image_prefix || ''libraries/apex/minified/'' ,',
'            p_version    => null',
'          );',
'      apex_javascript.add_library(',
'        p_name       => ''widget.datepicker.min.js?v=4.2.5.00.08'',',
'        p_directory  => apex_application.g_image_prefix || ''libraries/apex/minified/'' ,',
'        p_version    => null',
'      );',
'      ',
'      ',
'      apex_javascript.add_onload_code (p_code => v_html);',
'      -- Load javascript Libraries',
'',
'      v_result.is_navigable := FALSE;',
'',
'    END IF; ',
'    RETURN v_result;',
'  end render_item;'))
,p_render_function=>'render_item'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:FORMAT_MASK_DATE:ELEMENT:WIDTH:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'	<img src="http://www.relational.es/relational.jpg" width="200px" /></p>',
'<p>',
'	<u><strong>Relational: Date and Hour Picker</strong></u></p>',
'<ul>',
'	<li>',
'		Plug-in Type: Item</li>',
'	<li>',
'		Version: 1.0 (2012/08/08)</li>',
'	<li>',
'		Description: This plugin allows user to select date and time in two separate HTML fields. APEX developer retrieves only one field with resulting concatenated values.</li>',
'</ul>',
'<div>',
'	<u><strong>Contact</strong></u></div>',
'<div>',
'	Developed by <strong>Josep Coves Barreiro</strong>, Freelance Computer Engineer&nbsp;</div>',
'<div>',
'	<em>josepcoves@relational.es / josepcoves@gmail.com</em></div>',
'<div>',
'	&nbsp;</div>',
'<div>',
'	<strong><u>Help</u></strong></div>',
'<div>',
'	To use this plugin, create an item (of type plugin) and select the &quot;Relational: Date and hour picker&quot; plugin. Relevant parameters:</div>',
'<div>',
'	&nbsp;</div>',
'<ul>',
'	<li>',
'		Standard &quot;HTML Form Element Attributes&quot;: Adds attributes to Date field</li>',
'	<li>',
'		<strong>Timestamp Format</strong> <strong>(Required)</strong>: Format of Hour field</li>',
'	<li>',
'		<strong>Default Timestamp Value&nbsp;(Required)</strong>: Default value to be selected when item has no session value</li>',
'	<li>',
'		<strong>Date Format</strong>&nbsp;<strong>(Required)</strong>: Format of Date field</li>',
'	<li>',
'		<strong>Date Default Value</strong>&nbsp;<strong>(Required)</strong>: Default value to be selected when item has no session value</li>',
'	<li>',
'		Timestamp NAMED LOV: In case you want the Hour field to be a select list, introduce here the APEX NAMED LOV.</li>',
'	<li>',
'		Timestamp HTML attributes: Additional HTML tags for Hour field</li>',
'	<li>',
'		Datepicker JS Attributes: Redefinition of standard datepicker apex.widget.datepicker call. See field info for an example.</li>',
'</ul>',
'<p>',
'	Plugin renders a hidden HTML input element, with item provided name, and the resulting date and timestamp selected by user.</p>',
'<p>',
'	Two display fields are rendered with names &lt;ITEM_NAME&gt;_DATE, and &lt;ITEM_NAME&gt;_HOUR which can be used to associate Dyamic Actions via triggering.</p>',
'<div>',
'	&nbsp;</div>',
'<div>',
'	<div>',
'		<strong><u>License</u></strong></div>',
'	<div>',
'		Licensed Under: GNU General Public License, version 3.0 - http://www.opensource.org/licenses/gpl-3.0.html</div>',
'</div>',
'<div>',
'	&nbsp;</div>',
'<p>',
'	&nbsp;</p>'))
,p_version_identifier=>'1.0'
,p_about_url=>'http://www.relational.es'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67215495119652868888)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Timestamp format'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'HH24:MI'
,p_is_translatable=>false
,p_help_text=>'Timestamp Format: For instance: HH24:MI, HH24:MI:SS, HH:MI, etc.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67216224526241946499)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Default Timestamp Value'
,p_attribute_type=>'PLSQL EXPRESSION'
,p_is_required=>true
,p_default_value=>'to_char(sysdate,''HH24:MI'')'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Timestamp default value. This must be a PL/SQL Expression.',
'<br>Examples:<br>',
'<br>',
'''00:00''<br>',
'to_char(sysdate,''HH:MI'')'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67216813132006014330)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Date Format'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'DD/MM/YYYY'
,p_is_translatable=>false
,p_help_text=>'Date format: DD/MM/YYY, DD-MON-YYYY, etc.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67216832809627017346)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Date Default Value'
,p_attribute_type=>'PLSQL EXPRESSION'
,p_is_required=>true
,p_default_value=>'to_char(sysdate,''dd/mm/yyyy'')'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Default Date value. This must be a PL/SQL expression returning varchar2 value. The format mask must match Date Format parameter. <br><br>',
'Examples:<br>',
'<br>',
'''23/11/2012''<br>',
'to_char(sysdate,''DD/MM/YYYY'')<br>',
''))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67273448521484119060)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Timestamp NAMED LOV'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>100
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'In case you want to show Timestamp value on a select list, you can set this attribute to the Named LOV which contains desired values. LOV must have two columns, first with display value and second with return value, which must match Timestamp Format:'
||'<br>',
'<br>',
'<strong>',
'Example (timestamp HH24:MI):<br></strong>',
'<br>',
'LOV_HOURS<br>',
'<br>',
'SELECT ''One'', ''01:00'' from dual<br>',
'union all<br>',
'SELECT ''Half past one'', ''01:30'' from dual<br>',
'<br>',
'<strong>',
'Example 2: Generate list of quarters: 00:15, 00:30, 00:45, 1:00, etc.<br></strong>',
'SELECT hour.val<br>',
'       ||'':''<br>',
'       ||quarter.val display, hour.val<br>',
'       ||'':''<br>',
'       ||quarter.val return<br>',
'FROM   (SELECT Lpad(LEVEL - 1, 2, ''0'') val<br>',
'        FROM   dual<br>',
'        CONNECT BY LEVEL <= 24) hour,<br>',
'       (SELECT Decode(LEVEL, 1, ''00'',<br>',
'                             2, ''15'',<br>',
'                             3, ''30'',<br>',
'                             ''45'') val<br>',
'        FROM   dual<br>',
'        CONNECT BY LEVEL <= 4) quarter<br>',
'ORDER  BY 1<br>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67282383620949405663)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Timestamp HTML attributes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Use this field to expand timestamp field, for instance: class="myclass"'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(67283321027978540110)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Datepicker JS Attributes'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'This setting allows you to rewrite apex.datepicker call with your custom parameters. Please, note that if you inform this field you must explicitly introduce all compulsory parameters, plugin call won''t introduce any of them.<br>',
'<br>',
'<b>Example</b>:',
'<br>',
'  "buttonImage": "/i/asfdcldr.gif",<br>',
'  "buttonImageOnly": true,<br>',
'  "buttonText": "Calendar",<br>',
'  "showTime": false,<br>',
'  "defaultDate": new Date(2012, 7, 06, 06, 36, 30),<br>',
'  "showOn": "button",<br>',
'  "showOtherMonths": false,<br>',
'  "changeMonth": false,<br>',
'  "changeYear": false<br>'))
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F2A2A2A2A2A2A2020414D45524943414E20202A2A2A2A2A2A0D0A617065782E6A51756572792866756E6374696F6E2824297B0D0A617065782E6A51756572792E646174657069636B65722E726567696F6E616C5B27656E275D203D207B0D0A636C6F';
wwv_flow_api.g_varchar2_table(2) := '7365546578743A2022436C6F7365222C0D0A70726576546578743A202250726576222C0D0A6E657874546578743A20224E657874222C0D0A63757272656E74546578743A2022546F646179222C0D0A6D6F6E74684E616D65733A205B224A616E75617279';
wwv_flow_api.g_varchar2_table(3) := '222C224665627275617279222C224D61726368222C22417072696C222C224D6179222C224A756E65222C224A756C79222C22417567757374222C2253657074656D626572222C224F63746F626572222C224E6F76656D626572222C22446563656D626572';
wwv_flow_api.g_varchar2_table(4) := '22205D2C0D0A6D6F6E74684E616D657353686F72743A205B224A616E222C22466562222C224D6172222C22417072222C224D6179222C224A756E222C224A756C222C22417567222C22536570222C224F6374222C224E6F76222C2244656322205D2C0D0A';
wwv_flow_api.g_varchar2_table(5) := '6461794E616D65733A205B2253756E646179222C224D6F6E646179222C2254756573646179222C225765646E6573646179222C225468757273646179222C22467269646179222C22536174757264617922205D2C0D0A6461794E616D657353686F72743A';
wwv_flow_api.g_varchar2_table(6) := '205B2253756E222C224D6F6E222C22547565222C22576564222C22546875222C22467269222C2253617422205D2C0D0A6461794E616D65734D696E3A205B225375222C224D6F222C225475222C225765222C225468222C224672222C22536122205D2C0D';
wwv_flow_api.g_varchar2_table(7) := '0A7765656B4865616465723A2022576B222C0D0A64617465466F726D61743A202264642D4D2D79222C66697273744461793A20302C0D0A697352544C3A2066616C73652C0D0A73686F774D6F6E74684166746572596561723A2066616C73652C0D0A7965';
wwv_flow_api.g_varchar2_table(8) := '61725375666669783A2022227D3B0D0A617065782E6A51756572792E646174657069636B65722E73657444656661756C747328617065782E6A51756572792E646174657069636B65722E726567696F6E616C5B27656E275D293B0D0A7D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(881712709367067448)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_file_name=>'jquery.ui.datepicker-en.js'
,p_mime_type=>'application/x-javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2866756E6374696F6E28612C62297B612E646174657069636B65723D66756E6374696F6E28632C642C652C66297B76617220673D6E756C6C3B69662821642E73686F7754696D657C7C642E73686F7754696D652626642E73686F774F6E3D3D22696E6C69';
wwv_flow_api.g_varchar2_table(2) := '6E652229673D66756E6374696F6E28612C62297B696628622E696E6C696E65297B76617220633D622E73657474696E67732E616C744669656C643B632E696E6465784F6628222322293D3D3D30262628633D632E73756273747228312C632E6C656E6774';
wwv_flow_api.g_varchar2_table(3) := '6829292C632626247328632C61297D656C736520247328622E69642C61297D3B76617220683D662C693D622E657874656E64287B64617465466F726D61743A652C6475726174696F6E3A22222C636F6E73747261696E496E7075743A21312C6F6E53656C';
wwv_flow_api.g_varchar2_table(4) := '6563743A672C6C6F63616C653A687D2C64292C6A3D622E646174657069636B65722E726567696F6E616C5B665D3B64656C657465206A2E6D6178446174652C64656C657465206A2E6D696E446174652C64656C657465206A2E64656661756C7444617465';
wwv_flow_api.g_varchar2_table(5) := '2C64656C657465206A2E64617465466F726D61742C64656C657465206A2E7965617252616E67652C64656C657465206A2E6E756D6265724F664D6F6E7468732C64656C657465206A2E616C744669656C642C693D622E657874656E64286A2C69293B7661';
wwv_flow_api.g_varchar2_table(6) := '72206B3D6228632C617065782E6750616765436F6E7465787424292E646174657069636B65722869293B6228632C617065782E6750616765436F6E7465787424292E656163682866756E6374696F6E28297B612E696E6974506167654974656D28746869';
wwv_flow_api.g_varchar2_table(7) := '732E69642C7B656E61626C653A66756E6374696F6E28297B62282223222B746869732E69642C617065782E6750616765436F6E7465787424292E646174657069636B65722822656E61626C6522292E72656D6F7665436C6173732822617065785F646973';
wwv_flow_api.g_varchar2_table(8) := '61626C656422297D2C64697361626C653A66756E6374696F6E28297B62282223222B746869732E69642C617065782E6750616765436F6E7465787424292E646174657069636B6572282264697361626C6522292E616464436C6173732822617065785F64';
wwv_flow_api.g_varchar2_table(9) := '697361626C656422297D2C73686F773A66756E6374696F6E28297B62282223222B746869732E69642C617065782E6750616765436F6E7465787424292E706172656E7428292E6368696C6472656E28292E73686F7728297D2C686964653A66756E637469';
wwv_flow_api.g_varchar2_table(10) := '6F6E28297B62282223222B746869732E69642C617065782E6750616765436F6E7465787424292E706172656E7428292E6368696C6472656E28292E6869646528297D7D297D297D7D2928617065782E7769646765742C617065782E6A5175657279293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(881738308518068648)
,p_plugin_id=>wwv_flow_api.id(67059297306859688506)
,p_file_name=>'widget.datepicker.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
