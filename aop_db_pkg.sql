set define off verify off feedback off

create or replace package aop_api19_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2019 - APEX RnD
*/

-- CONSTANTS
 
/* AOP Version */
c_aop_version               constant varchar2(5)  := '19.1';                                 -- The version of APEX Office Print (AOP)
c_aop_url                   constant varchar2(50) := 'http://api.apexofficeprint.com/';      -- The default url for the AOP Server
                                                                                             -- for https use https://api.apexofficeprint.com/
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
c_source_type_url_aop       constant varchar2(7)  := 'URL_AOP';   -- Template Type
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
c_mime_type_docm            constant varchar2(48) := 'application/vnd.ms-word.document.macroenabled.12';
c_mime_type_xlsm            constant varchar2(46) := 'application/vnd.ms-excel.sheet.macroenabled.12';
c_mime_type_pptm            constant varchar2(58) := 'application/vnd.ms-powerpoint.presentation.macroenabled.12';
c_mime_type_ics             constant varchar2(13) := 'text/calendar';
c_mime_type_ifb             constant varchar2(13) := 'text/calendar';
-- Calender Type
c_cal_month                 constant varchar2(19) := 'month';
c_cal_week                  constant varchar2(19) := 'week';
c_cal_day                   constant varchar2(19) := 'day';
c_cal_list                  constant varchar2(19) := 'list';
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
c_word_macro_docm           constant varchar2(4)  := 'docm';
c_excel_macro_xlsm          constant varchar2(4)  := 'xlsm';
c_powerpoint_macro_pptm     constant varchar2(4)  := 'pptm'; 
c_calendar_ics              constant varchar2(3)  := 'ics';
c_calendar_ifb              constant varchar2(3)  := 'ifb';
c_onepagepdf_pdf            constant varchar2(10) := 'onepagepdf';
c_count_tags                constant varchar2(10) := 'count_tags';
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
c_converter_libreoffice     constant varchar2(7)  := 'soffice';      -- LibreOffice 
c_converter_msoffice        constant varchar2(11) := 'officetopdf';  -- MS Office (only Windows)
c_converter_custom          constant varchar2(7)  := 'custom';       -- Custom converter defined in the AOP Server config
-- Mode
c_mode_production           constant varchar2(15) := 'production';
c_mode_development          constant varchar2(15) := 'development';
-- Supported Languages; used for the translation of IR
c_en                        constant varchar2(5)  := 'en';
c_nl                        constant varchar2(5)  := 'nl';
c_fr                        constant varchar2(5)  := 'fr';
c_de                        constant varchar2(5)  := 'de';
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
                                                    -- SQL> ALTER PACKAGE aop_api19_pkg COMPILE PLSQL_CCFLAGS = 'logger_on:TRUE'; 
                                                    -- When compiled and this global variable is set to true, debug will be written to logger too
-- Call to AOP
g_aop_url                   varchar2(100) := null;  -- AOP Server url
g_api_key                   varchar2(50)  := null;  -- AOP API Key; only needed when AOP Cloud is used (http(s)://www.apexofficeprint.com/api)
g_aop_mode                  varchar2(15)  := null;  -- AOP Mode can be development or production; when running in development no cloud credits are used but a watermark is printed                                                    
g_failover_aop_url          varchar2(100) := null;  -- AOP Server url in case of failure of AOP url
g_failover_procedure        varchar2(200) := null;  -- When the failover url is used, the procedure specified in this variable will be called
g_output_converter          varchar2(50)  := null;  -- Set the converter to go to PDF (or other format different from template) e.g. officetopdf or libreoffice
g_proxy_override            varchar2(300) := null;  -- null=proxy defined in the application attributes
g_transfer_timeout          number(6)     := 1800;  -- default of APEX is 180
g_wallet_path               varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_wallet_pwd                varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_output_filename           varchar2(300) := null;  -- output
g_cloud_provider            varchar2(30)  := null;  -- dropbox, gdrive, onedrive, aws_s3
g_cloud_location            varchar2(300) := null;  -- directory in dropbox, gdrive, onedrive, aws_s3 (with bucket)
g_cloud_access_token        varchar2(500) := null;  -- access token for dropbox, gdrive, onedrive, aws_s3 (needs json)
g_language                  varchar2(2)   := c_en;  -- Language can be: en, fr, nl, de, used for the translation of filters applied etc. (translation build-in AOP)
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
g_cal_type                  varchar2(10)  := c_cal_month; -- can be month (default), week, day, list; constants can be used
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
-- Post Processing
g_post_process_command       varchar2(100) := null;  -- The command to execute. This command should be present on aop_config.json file. 
g_post_process_return_output boolean       := true;  -- Either to return the output or not. Note this output is AOP's output and not the post process command output. 
g_post_process_delete_delay  number(9)     := 1500;  -- AOP deletes the file provided to the command directly after executing it. This can be delayed with this option. Integer in milliseconds. 
-- Convert characterset
g_convert                   varchar2(1)   := c_n;    -- set to Y (c_y) if you want to convert the JSON that is send over; necessary for Arabic support
g_convert_source_charset    varchar2(20)  := null;   -- default of database 
g_convert_target_charset    varchar2(20)  := 'AL32UTF8';  
-- Output
g_output_directory          varchar2(200) := '.';    -- set output directory on AOP Server
                                                     -- if . is specified the files are saved in the default directory: outputfiles
g_output_split              varchar2(5)   := null;   -- split file: one file per page: true/false
g_output_even_page          varchar2(5)   := null;   -- PDF option to always print even pages (necessary for two-sided pages): true/false
g_output_merge_making_even  varchar2(5)   := null;   -- PDF option to merge making all documents even paged (necessary for two-sided pages): true/false

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
g_output_watermark          varchar2(4000) := null;  -- Watermark in PDF                                                    

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
  p_data_type                 in varchar2 default c_source_type_sql,
  p_data_source               in clob,
  p_template_type             in varchar2 default c_source_type_apex,
  p_template_source           in clob,
  p_output_type               in varchar2,
  p_output_filename           in out nocopy varchar2,
  p_output_type_item_name     in varchar2 default null,
  p_output_to                 in varchar2 default null,
  p_procedure                 in varchar2 default null,
  p_binds                     in wwv_flow_plugin_util.t_bind_list default c_binds,
  p_special                   in varchar2 default null,
  p_aop_remote_debug          in varchar2 default c_no,
  p_output_converter          in varchar2 default null,
  p_aop_url                   in varchar2,
  p_api_key                   in varchar2 default null,
  p_aop_mode                  in varchar2 default null,
  p_app_id                    in number   default null,
  p_page_id                   in number   default null,
  p_user_name                 in varchar2 default null,
  p_init_code                 in clob     default c_init_null,
  p_output_encoding           in varchar2 default c_output_encoding_raw,
  p_output_split              in varchar2 default c_false,
  p_output_even_page          in varchar2 default c_false,
  p_output_merge_making_even  in varchar2 default c_false,
  p_failover_aop_url          in varchar2 default null,
  p_failover_procedure        in varchar2 default null,
  p_log_procedure             in varchar2 default null,
  p_prepend_files_sql         in clob     default null,
  p_append_files_sql          in clob     default null,
  p_sub_templates_sql         in clob     default null)
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

end aop_api19_pkg;
/


create or replace package body aop_api19_pkg wrapped 
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
462a1 cadf
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
1dcgGwFtaddWNLalil21OrX71SQsBw==

/
create or replace package aop_plsql19_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2019 - APEX RnD
*/

/* AOP Version */
c_aop_version  constant varchar2(5)   := '19.1';

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

end aop_plsql19_pkg;
/
/**
 * @Description: Package to show how to make a manual call with PL/SQL to the AOP Server
 *               If APEX is not installed, you can use this package as your starting point but you would need to change the apex_web_service calls by utl_http calls or similar.
 *
 * @Author: Dimitri Gielis
 * @Created: 12/12/2015
 */

create or replace package body aop_plsql19_pkg as


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

end aop_plsql19_pkg;
/
create or replace package aop_convert19_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2019 - APEX RnD
*/

-- CONSTANTS

/* AOP Version */
c_aop_version             constant varchar2(5) := '19.1';
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


end aop_convert19_pkg;
/
create or replace package body aop_convert19_pkg wrapped 
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
create or replace synonym aop_api_pkg for aop_api19_pkg;
create or replace synonym aop_plsql_pkg for aop_plsql19_pkg;
create or replace synonym aop_convert_pkg for aop_convert19_pkg;
