set define off verify off feedback off

create or replace package aop_api18_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2018 - APEX RnD
*/

-- CONSTANTS
 
/* AOP Version */
c_aop_version               constant varchar2(5)  := '18.2';                                 -- The version of APEX Office Print (AOP)
c_aop_url                   constant varchar2(50) := 'http://api.apexofficeprint.com/';      -- The default url for the AOP Server
                                                                                             -- for https use https://api.apexofficeprint.com/
                                                                                             -- alternative https url https://www.apexrnd.be/aop/
c_aop_url_fallback          constant varchar2(50) := 'http://www.cloudofficeprint.com/aop/'; -- The default url for the AOP Fallback Server in case the c_aop_url would fail
                                                                                             -- for https use https://www.cloudofficeprint.com/aop/

-- Available constants
-- Template and Data Type
c_source_type_apex          constant varchar2(4)  := 'APEX';      -- Template Type
c_source_type_workspace     constant varchar2(9)  := 'WORKSPACE'; -- Template Type
c_source_type_sql           constant varchar2(3)  := 'SQL';       -- Template and Data Type
c_source_type_plsql_sql     constant varchar2(9)  := 'PLSQL_SQL'; -- Template and Data Type
c_source_type_plsql         constant varchar2(5)  := 'PLSQL';     -- Template and Data Type
c_source_type_url           constant varchar2(3)  := 'URL';       -- Template and Data Type
c_source_type_rpt           constant varchar2(6)  := 'IR';        -- Data Type
c_source_type_filename      constant varchar2(8)  := 'FILENAME';  -- Template Type
-- Converter
c_source_type_converter     constant varchar2(9)  := 'CONVERTER';
-- Mime Type
c_mime_type_docx            constant varchar2(71) := 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
c_mime_type_xlsx            constant varchar2(65) := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
c_mime_type_pptx            constant varchar2(73) := 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
c_mime_type_pdf             constant varchar2(15) := 'application/pdf';
c_mime_type_html            constant varchar2(9)  := 'text/html';
c_mime_type_markdown        constant varchar2(13) := 'text/markdown';
c_mime_type_rtf             constant varchar2(15) := 'application/rtf';
c_mime_type_json            constant varchar2(16) := 'application/json';
c_mime_type_text            constant varchar2(10) := 'text/plain';
c_mime_type_csv             constant varchar2(10) := 'text/csv';
c_mime_type_png             constant varchar2(9)  := 'image/png';
c_mime_type_jpg             constant varchar2(10) := 'image/jpeg';
c_mime_type_gif             constant varchar2(9)  := 'image/gif';
c_mime_type_bmp             constant varchar2(9)  := 'image/bmp';
c_mime_type_msbmp           constant varchar2(19) := 'image/x-windows-bmp';
-- Output Encoding
c_output_encoding_raw       constant varchar2(3)  := 'raw';
c_output_encoding_base64    constant varchar2(6)  := 'base64';
-- Output Type
c_word_docx                 constant varchar2(4)  := 'docx';
c_excel_xlsx                constant varchar2(4)  := 'xlsx';
c_powerpoint_pptx           constant varchar2(4)  := 'pptx'; 
c_pdf_pdf                   constant varchar2(3)  := 'pdf'; 
c_html_html                 constant varchar2(4)  := 'html';
c_markdown_md               constant varchar2(2)  := 'md';
c_text_txt                  constant varchar2(3)  := 'txt'; 
c_csv_csv                   constant varchar2(3)  := 'csv'; 
c_word_rtf                  constant varchar2(3)  := 'rtf';
c_onepagepdf_pdf            constant varchar2(10) := 'onepagepdf';
c_count_tags                constant varchar2(10)  := 'count_tags';
c_defined_by_apex_item      constant varchar2(9)  := 'apex_item';
-- Output To
c_output_browser            constant varchar2(1)  := null;
c_output_procedure          constant varchar2(9)  := 'PROCEDURE';
c_output_procedure_browser  constant varchar2(17) := 'PROCEDURE_BROWSER';
c_output_inline             constant varchar2(14) := 'BROWSER_INLINE'; 
c_output_directory          constant varchar2(9)  := 'DIRECTORY';
c_output_cloud              constant varchar2(5)  := 'CLOUD';
-- Special
c_special_number_as_string  constant varchar2(16) := 'NUMBER_TO_STRING';
c_special_report_as_label   constant varchar2(16) := 'REPORT_AS_LABELS';
c_special_ir_filters_top    constant varchar2(14) := 'FILTERS_ON_TOP';
c_special_ir_highlights_top constant varchar2(17) := 'HIGHLIGHTS_ON_TOP';
c_special_ir_excel_header_f constant varchar2(18) := 'HEADER_WITH_FILTER';
c_special_ir_saved_report   constant varchar2(19) := 'ALWAYS_REPORT_ALIAS';
c_special_ir_repeat_header  constant varchar2(13) := 'repeat_header';
-- Debug
c_debug_remote              constant varchar2(3)  := 'Yes';
c_debug_local               constant varchar2(5)  := 'Local';
c_debug_application_item    constant varchar2(9)  := 'APEX_ITEM';
-- Converter
c_converter_libreoffice     constant varchar2(1)  := null;           -- LibreOffice is the default converter
c_converter_msoffice        constant varchar2(11) := 'officetopdf';  -- MS Office on Windows
c_converter_custom          constant varchar2(7)  := 'custom';       -- Custom converter defined in the AOP Server config
/* Strings */
c_init_null                 constant varchar2(5)  := 'null;';
c_false                     constant varchar2(5)  := 'false';
c_true                      constant varchar2(4)  := 'true';
c_yes                       constant varchar2(3)  := 'Yes';
c_no                        constant varchar2(2)  := 'No';
c_y                         constant varchar2(1)  := 'Y';
c_n                         constant varchar2(1)  := 'N';
/* Internal Use for conditional compilation */
c_apex_050                  constant pls_integer  := 20130101;
c_apex_051                  constant pls_integer  := 20160824;
c_apex_181                  constant pls_integer  := 20180404;


-- TYPES
/**
 * @types
 */

--type t_bind_record is record(name varchar2(100), value varchar2(32767));
--type t_bind_table  is table of t_bind_record index by pls_integer;
c_binds wwv_flow_plugin_util.t_bind_list;


-- VARIABLES

-- Logger
g_logger_enabled            boolean := true;        -- In case you use Logger (https://github.com/OraOpenSource/Logger), you can compile this package to enable Logger output:
                                                    -- SQL> ALTER PACKAGE aop_api18_pkg COMPILE PLSQL_CCFLAGS = 'logger_on:TRUE'; 
                                                    -- When compiled and this global variable is set to true, debug will be written to logger too
-- Call to AOP
g_aop_url                   varchar2(100) := null;  -- AOP Server url
g_api_key                   varchar2(50)  := null;  -- AOP API Key; only needed when AOP Cloud is used (http(s)://www.apexofficeprint.com/api)
g_failover_aop_url          varchar2(100) := null;  -- AOP Server url in case of failure of AOP url
g_failover_procedure        varchar2(200) := null;  -- When the failover url is used, the procedure specified in this variable will be called
g_output_converter          varchar2(50)  := null;  -- Set the converter to go to PDF (or other format different from template) e.g. officetopdf or libreoffice
g_proxy_override            varchar2(300) := null;  -- null=proxy defined in the application attributes
g_transfer_timeout          number(6)     := 1800;  -- default of APEX is 180
g_wallet_path               varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_wallet_pwd                varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_output_filename           varchar2(100) := null;  -- output
g_cloud_provider            varchar2(30)  := null;  -- dropbox, gdrive, onedrive, aws_s3
g_cloud_location            varchar2(300) := null;  -- directory in dropbox, gdrive, onedrive, aws_s3 (with bucket)
g_cloud_access_token        varchar2(500) := null;  -- access token for dropbox, gdrive, onedrive, aws_s3 (needs json)
g_language                  varchar2(2)   := 'en';  -- Language can be: en, fr, nl, de, used for the translation of filters applied etc. (translation build-in AOP)
g_app_language              varchar2(20)  := null;  -- Language specified in the APEX app (primary language, translated language), when left to null, apex_util.get_session_lang is being used
g_logging                   clob          := '';    -- ability to add your own logging: e.g. "request_id":"123", "request_app":"APEX", "request_user":"RND"
g_debug                     varchar2(10)  := null;  -- set to 'Local' when only the JSON needs to be generated, 'Remote' for remore debug
g_debug_procedure           varchar2(4000):= null;  -- when debug in APEX is turned on, next to the normal APEX debug, this procedure will be called
                                                    --   e.g. to write to your own debug table. The definition of the procedure needs to be the same as aop_debug
-- APEX Page Items
g_apex_items                varchar2(4000):= null;  -- colon separated list of APEX items e.g. P1_X:P1_Y, which can be referenced in a template using {Pxx_ITEM}                                                    
-- Layout for IR 
g_rpt_header_font_name      varchar2(50)  := '';    -- Arial - see https://www.microsoft.com/typography/Fonts/product.aspx?PID=163
g_rpt_header_font_size      varchar2(3)   := '';    -- 14
g_rpt_header_font_color     varchar2(50)  := '';    -- #071626
g_rpt_header_back_color     varchar2(50)  := '';    -- #FAFAFA
g_rpt_header_border_width   varchar2(50)  := '';    -- 1 ; '0' = no border
g_rpt_header_border_color   varchar2(50)  := '';    -- #000000
g_rpt_data_font_name        varchar2(50)  := '';    -- Arial - see https://www.microsoft.com/typography/Fonts/product.aspx?PID=163
g_rpt_data_font_size        varchar2(3)   := '';    -- 14
g_rpt_data_font_color       varchar2(50)  := '';    -- #000000
g_rpt_data_back_color       varchar2(50)  := '';    -- #FFFFFF
g_rpt_data_border_width     varchar2(50)  := '';    -- 1 ; '0' = no border
g_rpt_data_border_color     varchar2(50)  := '';    -- #000000
g_rpt_data_alt_row_color    varchar2(50)  := '';    -- #FFFFFF for no alt row color, use same color as g_rpt_data_back_color
/* see also Printing attributes in Interactive Report */
-- Settings for Calendar
g_cal_type                  varchar2(10)  := 'month'; -- can be month (default), week, day, list
g_start_date                date          := null;    -- start date of calendar
g_end_date                  date          := null;    -- end date of calendar
g_weekdays                  varchar2(300) := null;    -- translation for weekdays e.g. Monday:Tuesday:Wednesday etc.
g_months                    varchar2(300) := null;    -- translation for months   e.g. January:February etc.  
g_color_days_sql            varchar2(4000):= null;    -- color the background of certain days. 
                                                      --   e.g. select 1 as "id", sysdate as "date", 'FF8800' as "color" from dual
-- HTML template to Word/PDF
g_orientation               varchar2(50)  := '';      -- empty is portrait, other option is 'landscape'
-- Call to URL data source
g_url_username              varchar2(300) := null;
g_url_password              varchar2(300) := null;
g_url_proxy_override        varchar2(300) := null;
g_url_transfer_timeout      number        := 180;
g_url_body                  clob          := empty_clob();
g_url_body_blob             blob          := empty_blob();
g_url_parm_name             apex_application_global.vc_arr2; --:= empty_vc_arr;
g_url_parm_value            apex_application_global.vc_arr2; --:= empty_vc_arr;
g_url_wallet_path           varchar2(300) := null;
g_url_wallet_pwd            varchar2(300) := null;
g_url_https_host            varchar2(300) := null;    -- parameter for apex_web_service, not used, please apply APEX patch if issues
-- Web Source Module (APEX >= 18.1)
g_web_source_first_row      pls_integer   := null;    -- parameter for apex_exec.open_web_source_query
g_web_source_max_rows       pls_integer   := null;    -- parameter for apex_exec.open_web_source_query
g_web_source_total_row_cnt  boolean       := false;   -- parameter for apex_exec.open_web_source_query
-- REST Enabled SQL (APEX >= 18.1)
g_rest_sql_auto_bind_items  boolean       := true;    -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_first_row        pls_integer   := null;    -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_max_rows         pls_integer   := null;    -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_total_row_cnt    boolean       := false;   -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_total_row_limit  pls_integer   := null;    -- parameter for apex_exec.open_remote_sql_query
-- IP Printer support
g_ip_printer_location       varchar2(300) := null;
g_ip_printer_version        varchar2(300) := '1';
g_ip_printer_requester      varchar2(300) := nvl(apex_application.g_user, USER);
g_ip_printer_job_name       varchar2(300) := 'AOP';
g_ip_printer_return_output  varchar2(5)   := null;   -- null or 'Yes' or 'true'
-- Convert characterset
g_convert                   varchar2(1)   := c_n;    -- set to Y (c_y) if you want to convert the JSON that is send over; necessary for Arabic support
g_convert_source_charset    varchar2(20)  := null;   -- default of database 
g_convert_target_charset    varchar2(20)  := 'AL32UTF8';  
-- Output
g_output_directory          varchar2(200) := '.';    -- set output directory on AOP Server
                                                     -- if . is specified the files are saved in the default directory: outputfiles
g_output_split              varchar2(5)   := null;   -- split file: one file per page: true/false

-- Files
g_prepend_files_sql         clob := null;    -- format: select filename, mime_type, [file_blob, file_base64, url_call_from_db, url_call_from_aop, file_on_aop_server]
g_append_files_sql          clob := null;    --           from my_table

-- Sub-Templates
g_sub_templates_sql         clob := null;    -- format: select filename, mime_type, [file_blob, file_base64, url_call_from_db, url_call_from_aop, file_on_aop_server] from my_table

-- Password protected PDF
g_output_read_password      varchar2(200) := null;  -- protect PDF to read
g_output_modify_password    varchar2(200) := null;  -- protect PDF to write (modify)
g_output_pwd_protection_flag number(4)    := null;  -- optional; default is 4. 
                                                    -- Number when bit calculation is done as specified in http://pdfhummus.com/post/147451287581/hummus-1058-and-pdf-writer-updates-encryption

-- EXCEPTIONS
  /**
   * @exception 
   */


-- FUNCTIONS AND PROCEDURES   
/**
 * Functions and Procedures
 * 
 * ! package body contains documentation
 */

-- debug function, will write to apex_debug_messages, logger (if enabled) and your own debug procedure
procedure aop_debug(p_message     in varchar2, 
                    p0            in varchar2 default null, 
                    p1            in varchar2 default null, 
                    p2            in varchar2 default null, 
                    p3            in varchar2 default null, 
                    p4            in varchar2 default null, 
                    p5            in varchar2 default null, 
                    p6            in varchar2 default null, 
                    p7            in varchar2 default null, 
                    p8            in varchar2 default null, 
                    p9            in varchar2 default null, 
                    p10           in varchar2 default null, 
                    p11           in varchar2 default null, 
                    p12           in varchar2 default null, 
                    p13           in varchar2 default null, 
                    p14           in varchar2 default null, 
                    p15           in varchar2 default null, 
                    p16           in varchar2 default null, 
                    p17           in varchar2 default null, 
                    p18           in varchar2 default null, 
                    p19           in varchar2 default null, 
                    p_level       in apex_debug.t_log_level default apex_debug.c_log_level_info, 
                    p_description in clob default null);

-- convert a url with for example an image to base64
function url2base64 (
  p_url in varchar2)
  return clob;

-- get the value of one of the above constants
function getconstantvalue (
  p_constant in varchar2)
  return varchar2 deterministic;

-- get the mime type of a file extention: docx, xlsx, pptx, pdf
function getmimetype (
  p_file_ext in varchar2)
  return varchar2 deterministic;

-- get the file extention of a mime type
function getfileextension (
  p_mime_type in varchar2)
  return varchar2 deterministic;  

-- convert a blob to a clob
function blob2clob(p_blob in blob)
  return clob;

-- internal function to check a server-side condition
function is_component_used_yn(p_build_option_id         in number default null,
                              p_authorization_scheme_id in varchar2,
                              p_condition_type          in varchar2,
                              p_condition_expression1   in varchar2,
                              p_condition_expression2   in varchar2,
                              p_component               in varchar2 default null)
  return varchar2;

-- Manual call to AOP
-- p_aop_remote_debug: 
--   - No            : No debugging (= Default)
--   - Yes (=Remote) : Data is send to the AOP cloud server
--   - Local         : A JSON file is generated locally from your database server
-- p_special options: NUMBER_TO_STRING, ALWAYS_REPORT_ALIAS, FILTERS_ON_TOP, HIGHLIGHTS_ON_TOP, HEADER_WITH_FILTER
-- usage: p_special => 'ALWAYS_REPORT_ALIAS' or multiple p_special => 'FILTERS_ON_TOP:HIGHLIGHTS_ON_TOP'
function plsql_call_to_aop(
  p_data_type             in varchar2 default c_source_type_sql,
  p_data_source           in clob,
  p_template_type         in varchar2 default c_source_type_apex,
  p_template_source       in clob,
  p_output_type           in varchar2,
  p_output_filename       in out nocopy varchar2,
  p_output_type_item_name in varchar2 default null,
  p_output_to             in varchar2 default null,
  p_procedure             in varchar2 default null,
  p_binds                 in wwv_flow_plugin_util.t_bind_list default c_binds,
  p_special               in varchar2 default null,
  p_aop_remote_debug      in varchar2 default c_no,
  p_output_converter      in varchar2 default null,
  p_aop_url               in varchar2,
  p_api_key               in varchar2 default null,
  p_app_id                in number   default null,
  p_page_id               in number   default null,
  p_user_name             in varchar2 default null,
  p_init_code             in clob     default c_init_null,
  p_output_encoding       in varchar2 default c_output_encoding_raw,
  p_output_split          in varchar2 default c_false,
  p_failover_aop_url      in varchar2 default null,
  p_failover_procedure    in varchar2 default null,
  p_log_procedure         in varchar2 default null,
  p_prepend_files_sql     in clob     default null,
  p_append_files_sql      in clob     default null,
  p_sub_templates_sql     in clob     default null)
  return blob;

-- retrieve underlaying PL/SQL code of APEX Plug-in call
function show_plsql_call_plugin(
  p_process_id            in number   default null,
  p_dynamic_action_id     in number   default null,
  p_show_api_key          in varchar2 default c_no)
  return clob;


-- APEX Plugins

-- Process Type Plugin
function f_process_aop(
  p_process in apex_plugin.t_process,
  p_plugin  in apex_plugin.t_plugin)
  return apex_plugin.t_process_exec_result;

-- Dynamic Action Plugin
function f_render_aop (
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin)
  return apex_plugin.t_dynamic_action_render_result;

function f_ajax_aop(
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin)
  return apex_plugin.t_dynamic_action_ajax_result;


-- Other Procedure

-- Create an APEX session from PL/SQL
-- p_enable_debug: Yes / No (default)
procedure create_apex_session(
  p_app_id       in apex_applications.application_id%type,
  p_user_name    in apex_workspace_sessions.user_name%type default 'ADMIN',
  p_page_id      in apex_application_pages.page_id%type default null,
  p_session_id   in apex_workspace_sessions.apex_session_id%type default null,
  p_enable_debug in varchar2 default 'No');

-- Get the current APEX Session
function get_apex_session
  return apex_workspace_sessions.apex_session_id%type;

-- Join an APEX Session
procedure join_apex_session(
  p_session_id   in apex_workspace_sessions.apex_session_id%type,
  p_app_id       in apex_applications.application_id%type default null,
  p_page_id      in apex_application_pages.page_id%type default null,
  p_enable_debug in varchar2 default 'No');

-- Drop the current APEX Session
procedure drop_apex_session(
  p_app_id     in apex_applications.application_id%type default null,
  p_session_id in apex_workspace_sessions.apex_session_id%type default null);

end aop_api18_pkg;
/


create or replace package body aop_api18_pkg wrapped 
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
44678 c5cd
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

/
create or replace package aop_plsql18_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2018 - APEX RnD
*/

/* AOP Version */
c_aop_version  constant varchar2(5)   := '18.2';

--
-- Pre-requisites: apex_web_service package
-- if APEX is not installed, you can use this package as your starting point
-- but you would need to change the apex_web_service calls by utl_http calls or similar
--


--
-- Change following variables for your environment
--
g_aop_url  varchar2(200) := 'http://api.apexofficeprint.com/'; -- for https use https://api.apexofficeprint.com/
g_api_key  varchar2(200) := '';                                -- change to your API key

-- Global variables
-- Call to AOP
g_proxy_override          varchar2(300) := null;  -- null=proxy defined in the application attributes
g_transfer_timeout        number(6)     := 180;   -- default is 180
g_wallet_path             varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_wallet_pwd              varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings

-- Constants
c_mime_type_docx        varchar2(100) := 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
c_mime_type_xlsx        varchar2(100) := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
c_mime_type_pptx        varchar2(100) := 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
c_mime_type_pdf         varchar2(100) := 'application/pdf';

function make_aop_request(
  p_aop_url          in varchar2 default g_aop_url,
  p_api_key          in varchar2 default g_api_key,
  p_json             in clob,
  p_template         in blob,
  p_output_encoding  in varchar2 default 'raw', -- change to raw to have binary, change to base64 to have base64 encoded
  p_output_type      in varchar2 default null,
  p_output_filename  in varchar2 default 'output',
  p_aop_remote_debug in varchar2 default 'No')
  return blob;

end aop_plsql18_pkg;
/
/**
 * @Description: Package to show how to make a manual call with PL/SQL to the AOP Server
 *               If APEX is not installed, you can use this package as your starting point but you would need to change the apex_web_service calls by utl_http calls or similar.
 *
 * @Author: Dimitri Gielis
 * @Created: 12/12/2015
 */

create or replace package body aop_plsql18_pkg as


function replace_with_clob(
   p_source in clob
  ,p_search in varchar2
  ,p_replace in clob
) return clob
as
  l_pos pls_integer;
begin
  l_pos := instr(p_source, p_search);
  if l_pos > 0 then
    return substr(p_source, 1, l_pos-1)
      || p_replace
      || substr(p_source, l_pos+length(p_search));
  end if;
  return p_source;
end replace_with_clob;


/**
 * @Description: Example how to make a manual call to the AOP Server and generate the correct JSON.               
 *
 * @Author: Dimitri Gielis
 * @Created: 9/1/2018
 *
 * @Param: p_aop_url URL of AOP Server
 * @Param: p_api_key API Key in case AOP Cloud is used
 * @Param: p_json Data in JSON format
 * @Param: p_template Template in blob format
 * @Param: p_output_encoding Encoding in raw or base64
 * @Param: p_output_type The extension of the output e.g. pdf, if no output type is defined, the same extension as the template is used
 * @Param: p_output_filename Filename of the result
 * @Param: p_aop_remote_debug Ability to do remote debugging in case the AOP Cloud is used
 * @Return: Resulting file where the template and data are merged and outputted in the requested format (output type).
 */
function make_aop_request(
  p_aop_url          in varchar2 default g_aop_url,
  p_api_key          in varchar2 default g_api_key,
  p_json             in clob,
  p_template         in blob,
  p_output_encoding  in varchar2 default 'raw',  
  p_output_type      in varchar2 default null,
  p_output_filename  in varchar2 default 'output',
  p_aop_remote_debug in varchar2 default 'No')
  return blob
as
  l_output_converter  varchar2(20) := ''; --default
  l_aop_json          clob;
  l_template_clob     clob;
  l_template_type     varchar2(4);
  l_data_json         clob;
  l_output_type       varchar2(4);
  l_blob              blob;
  l_error_description varchar2(32767);
begin
  l_template_clob := apex_web_service.blob2clobbase64(p_template);
  l_template_clob := replace(l_template_clob, chr(13) || chr(10), null);
  l_template_clob := replace(l_template_clob, '"', '\u0022');
  if dbms_lob.instr(p_template, utl_raw.cast_to_raw('ppt/presentation'))> 0
  then
    l_template_type := 'pptx';
  elsif dbms_lob.instr(p_template, utl_raw.cast_to_raw('worksheets/'))> 0
  then
    l_template_type := 'xlsx';
  elsif dbms_lob.instr(p_template, utl_raw.cast_to_raw('word/document'))> 0
  then
    l_template_type := 'docx';
  else
    l_template_type := 'unknown';
  end if;

  if p_output_type is null
  then
    l_output_type := l_template_type;
  else
    l_output_type := p_output_type;
  end if;

  l_data_json := p_json;

  l_aop_json := '
  {
      "version": "***AOP_VERSION***",
      "api_key": "***AOP_API_KEY***",
      "aop_remote_debug": "***AOP_REMOTE_DEBUG***",
      "template": {
        "file":"***AOP_TEMPLATE_BASE64***",
         "template_type": "***AOP_TEMPLATE_TYPE***"
      },
      "output": {
        "output_encoding": "***AOP_OUTPUT_ENCODING***",
        "output_type": "***AOP_OUTPUT_TYPE***",
        "output_converter": "***AOP_OUTPUT_CONVERTER***"
      },
      "files":
        ***AOP_DATA_JSON***
  }';

  l_aop_json := replace(l_aop_json, '***AOP_VERSION***', c_aop_version);
  l_aop_json := replace(l_aop_json, '***AOP_API_KEY***', p_api_key);
  l_aop_json := replace(l_aop_json, '***AOP_REMOTE_DEBUG***', p_aop_remote_debug);
  l_aop_json := replace_with_clob(l_aop_json, '***AOP_TEMPLATE_BASE64***', l_template_clob);
  l_aop_json := replace_with_clob(l_aop_json, '***AOP_TEMPLATE_TYPE***', l_template_type);
  l_aop_json := replace(l_aop_json, '***AOP_OUTPUT_ENCODING***', p_output_encoding);
  l_aop_json := replace(l_aop_json, '***AOP_OUTPUT_TYPE***', l_output_type);
  l_aop_json := replace(l_aop_json, '***AOP_OUTPUT_CONVERTER***', l_output_converter);
  l_aop_json := replace_with_clob(l_aop_json, '***AOP_DATA_JSON***', l_data_json);
  l_aop_json := replace(l_aop_json, '\\n', '\n');

  apex_web_service.g_request_headers(1).name := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/json';

  begin
    l_blob := apex_web_service.make_rest_request_b(
      p_url              => p_aop_url,
      p_http_method      => 'POST',
      p_body             => l_aop_json,
      p_proxy_override   => g_proxy_override,
      p_transfer_timeout => g_transfer_timeout,
      p_wallet_path      => g_wallet_path,
      p_wallet_pwd       => g_wallet_pwd);
  exception
  when others
  then
    raise_application_error(-20001,'Issue calling AOP Service (REST call: ' || apex_web_service.g_status_code || '): ' || CHR(10) || SQLERRM);
  end;

  -- read header variable and create error message
  -- HTTP Status Codes:
  --  200 is normal
  --  500 error received
  --  503 Service Temporarily Unavailable, the AOP server is probably not running
  if apex_web_service.g_status_code = 200
  then
    l_error_description := null;
  elsif apex_web_service.g_status_code = 503
  then
    l_error_description := 'AOP Server not running.';
  elsif apex_web_service.g_status_code = 500
  then
    for l_loop in 1.. apex_web_service.g_headers.count loop
      if apex_web_service.g_headers(l_loop).name = 'error_description'
      then
        l_error_description := apex_web_service.g_headers(l_loop).value;
        -- errors returned by AOP server are base64 encoded
        l_error_description := utl_encode.text_decode(l_error_description, 'AL32UTF8', UTL_ENCODE.BASE64);
      end if;
    end loop;
  else
    l_error_description := 'Unknown error. Check AOP server logs.';
  end if;

  -- YOU CAN STORE THE L_BLOB TO A LOCAL DEBUG TABLE AS AOP SERVER RETURNS A DOCUMENT WITH MORE INFORMATION
  --

  -- check if succesfull
  if apex_web_service.g_status_code <> 200
  then
    raise_application_error(-20002,'Issue returned by AOP Service (REST call: ' || apex_web_service.g_status_code || '): ' || CHR(10) || l_error_description);
  end if;

  -- return print
  return l_blob;

end make_aop_request;

end aop_plsql18_pkg;
/
create or replace package aop_convert18_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2018 - APEX RnD
*/

-- CONSTANTS

/* AOP Version */
c_aop_version             constant varchar2(5) := '18.2';
c_aop_url                 constant varchar2(50) := 'http://api.apexofficeprint.com/'; -- for https use https://api.apexofficeprint.com/
-- Mime Types
c_mime_type_docx          constant varchar2(100) := 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
c_mime_type_xlsx          constant varchar2(100) := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
c_mime_type_pptx          constant varchar2(100) := 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
c_mime_type_pdf           constant varchar2(100) := 'application/pdf';
c_mime_type_html          constant varchar2(100) := 'text/html';
c_mime_type_markdown      constant varchar2(100) := 'text/markdown';
c_mime_type_rtf           constant varchar2(100) := 'application/rtf';
c_mime_type_json          constant varchar2(100) := 'application/json';
c_mime_type_text          constant varchar2(100) := 'text/plain';
c_mime_type_zip           constant varchar2(100) := 'application/zip';
-- Output
c_output_encoding_raw     constant varchar2(3) := 'raw';
c_output_encoding_base64  constant varchar2(6) := 'base64';
/* Init */
c_init_null               constant varchar2(5) := 'null;';
c_source_type_sql         constant varchar2(3) := 'SQL';

-- VARIABLES

-- Logger
g_logger_enabled          constant boolean := false;  -- set to true to write extra debug output to logger - see https://github.com/OraOpenSource/Logger

-- Call to AOP
g_proxy_override          varchar2(300) := null;  -- null=proxy defined in the application attributes
g_https_host              varchar2(300) := null;  -- parameter for utl_http and apex_web_service
g_transfer_timeout        number(6)     := 1800;  -- default of APEX is 180
g_wallet_path             varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_wallet_pwd              varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_output_filename         varchar2(100) := null;  -- output
g_language                varchar2(2)   := 'en';  -- Language can be: en, fr, nl, de
g_logging                 clob          := '';    -- ability to add your own logging: e.g. "request_id":"123", "request_app":"APEX", "request_user":"RND"
g_debug                   varchar2(10)  := null;  -- set to 'Local' when only the JSON needs to be generated, 'Remote' for remore debug
g_debug_procedure         varchar2(4000):= null;  -- when debug in APEX is turned on, next to the normal APEX debug, this procedure will be called
   

--
-- Convert one or more files by using a SQL query with following syntax (between [] can be one or more columns)
-- select filename, mime_type, [file_blob, file_base64, url_call_from_db, url_call_from_aop, file_on_aop_server] from my_table
--
function convert_files(
  p_query                 in clob,
  p_output_type           in varchar2,
  p_output_encoding       in varchar2 default c_output_encoding_raw,
  p_output_to             in varchar2 default null,
  p_output_filename       in out nocopy varchar2,  
  p_output_converter      in varchar2 default null,
  p_output_collection     in varchar2 default null,
  p_aop_remote_debug      in varchar2 default 'No',
  p_aop_url               in varchar2,
  p_api_key               in varchar2 default null,
  p_app_id                in number   default null,
  p_page_id               in number   default null,
  p_user_name             in varchar2 default null,
  p_init_code             in clob     default c_init_null,
  p_failover_aop_url      in varchar2 default null,
  p_failover_procedure    in varchar2 default null,
  p_log_procedure         in varchar2 default null
) return blob;


-- APEX Plugins

-- Process Type Plugin
/*
function f_process_aop(
  p_process in apex_plugin.t_process,
  p_plugin  in apex_plugin.t_plugin)
  return apex_plugin.t_process_exec_result;
*/
-- Dynamic Action Plugin
function f_render_aop (
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin)
  return apex_plugin.t_dynamic_action_render_result;

function f_ajax_aop(
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin)
  return apex_plugin.t_dynamic_action_ajax_result;


end aop_convert18_pkg;
/
create or replace package body aop_convert18_pkg wrapped 
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
3f7d 1347
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

/
create or replace synonym aop_api_pkg for aop_api18_pkg;
create or replace synonym aop_plsql_pkg for aop_plsql18_pkg;
create or replace synonym aop_convert_pkg for aop_convert18_pkg;
