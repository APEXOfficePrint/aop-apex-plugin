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
46281 cadf
K5knuyRYznQVT26HURXJONcsb/Awg83t+L8FUz0WI6rtk/b5Wz9Y/2N3xeVDV5b42djpDKA7
SodjXVfenRzRleikMpGhjV2RwNz/tT8t+y/bE8psbCnDQfRi993U9gsLCyRbNU6cj3rS3Pg7
vxkwvOPGbaGGXDTOgf/47sx85O6zKNCPtYDO1rnBB4DWTZp0upzMfURzNWierpZy1dZT/csH
pgQ/gwC7Li8qlqx9S0DdI+xPr/u18AqPDRUDj8KCmyOckEotnwuMgwf9PT9FzM2M8CckBU0z
TvAnnbRNM9nwJ52DdLrL3+VVtE0z7mANT0jD+BGMg3Lf5XPPjIOW3+VzwIyDZN8mpL8VeDhJ
CqR0FcRGWjyAUrCq3JqwS1Ox14oyaLmQgdcuoBU4gicoYM0/KOwRn5Kw5sHlRolPQMHNHN1n
tcRyVLH5+Be6Chl9Zor3QL4JiUXH9fmBckEPZLGz8wZVFB4IkSOKOhmclhzVzOv+QUlz59SP
3SFZQZeEr0Bjj6gPpVAJpT4PpSZjj/MPpYUJpYgPpVhjj8e8j8cMrx/Prx+nrJY6rJZiRA8I
RA8xG+SpT7geJSHO8WENODYvnKBiy++fUxp5MgQ4amx52WrjBNHeuixgS7ihBeF/BkYMgyvj
82ZxJWGiX32P8WEq4DY58vGWPbYWpJ9Aa4bU6V8FP5i5xB4/mD/ZzYP2a146NtGjzkb5HXtR
taVb9QRPB8xoxoClLMIDBLXmbI+XlHSDfZffzkM0PxzrmziWV81GYrml0b9daij7k4CqLz0E
AiCAQWo4ZJCpNXp+M1tfXc7oCU3wFsq22y3fkeyPSYx+p/kpEYNIEulvyGSihy0fMLLu/c9H
BH9Csgjl2zENRQDSIxAV+jVjfjIVxDhOwEae9Zg4CqQOrvn4XUhl72r/HW0Yzo2G6c9P2CuG
mBqLpJbLj+odP6QVZLClHuc/ANYPcu6xmc6B0z/tFQKhlHGwN9UquDs54jzdgatT4B2xfo/l
snF4QRsstz759bfY4py3lSNlT1yuNJGfxwYTn8i/rX7+/zrpAoTn/x9Xe4/DpqwooHaFIWlw
yuJneH+h23fLtmVZjHw6r4lEtrJZKKUrxph1uZzsU13kn2xtkmrvzpfbLDC2tcrnof/REi5H
T9CSCN58dE8sqJGkSmYEnr+wZ24jjkrRjIr0l0Xr4ZyMy4OL1z/V2B0l63J0J7Kox8Ep7kN9
imwVEeJ83qRQb5JHRQseTpN3u8ntGyxhdx4rWhIuDnsz7B7IJSC8hhplzUKYsYpGGqpQOvls
gwkQoE6a7ple3znOM2qMM8jKyqO/U7CQI7B9H1UekA6/HHj4AFl+g30oUSQZCPZkMoOk5jF7
7c+VGo99zb1bCqqf33QCJ7KSIwQqYiCMfBGThw9EzNDKtj/pTxVUeziuBfpOuEaHkNDRzlih
+pNQzQ8z20BKSsvcNIqlre162oQgUY/l4WTl2BOEwPvpXBW5cNLRQCCUMNdQ+14AOK1AdUVC
c4Ue7SnDEWT2GTU9Es2kWsHzTBtNZwWiwfvhdUqBnQ8SB4BbW0AnqV5NcoHJqTzhOKoYLZRE
MSWkbLGp806CKy4H/9y4eoD1+usxSFGB/QLvIWxzFuMZXAk05UKMfWVZNZGV+O14OCGrgfvN
UxVxag3YIZKxshnLBaqEd8iEwqsHCSqU2hNqnwobysdi6YygJJA/qsguOM5hAJviUNiehc5O
9rzXt9hX9i/yxwvKU1yGN3cWe1yuzkT94dOvLPXDlA94nsw2WDL91v+8+fSfbboMBDQ00RfM
TZPbdDp/SmvRXuaVtsr0CVKR/GX8dgnlo/tn1gQA9+dWHdyFXqn6Xkk50qVlg3evmPCKEj/G
s6wRR3W7mJ6uhjgE7d54aiN4zmxf7wRajvmB0/lBK1pbRixH/g6wyTw8m4LjlmDvVy2AH3Nv
1sHvnl2x8jeEcUcFv1IsefdNVZ69U8cp3q2F48YesvMZ24yfeEaC4YSnT6fWEJT1e+4WHDaM
md+9weTr192HDXqytAorjYCypJ6mSHYVuiMJ036oPRY894NJPgq3ONhAII+O5oR32+MGIVF/
O5/FjHrN/vOkHj2FClmTFGbt3aLK0yh+fCjnkB/hcSNfuGYM8GCeTjoKXMJxErFOMdc2ddwg
3w8S/vqStPjeQx2AoaUAC38plSkNCAZGuOJyheqOoAeo4LxbkJ+CqeL3sY1JB31x4RshAlZM
c3wf9MFH1EpredbUenZE7bMTDseIIzE2hgcbl6+94oA4d3n+g2rMmFiz0yZUY1K4ynYF9SqV
QMX5MjTsJFZktzBzQvfbhumbE3leDJUk15yd4m+GHhpnkD2d6ETyluhslx9+hp9lLsmG+GbW
MFTcbY1Ks3mYZ/BD4JBekj/ArtkZR2Sqx9HkBfVDhzAtVB8Wz8cecTNqkj/8cc4/NOSByfne
p144+UuHetiGkZ8AnVhHuQZDzl6vq7vGCl0698ed+b7scm6ZD2Qie5xMSZ2Uo3P4ZgqqD5GB
VZmu4uq5ASCaCzpnlFUfBQPQhildORE6JwBBO+36R4Q2Q7EITGarIXcQ8nkuCbeG3jRZPCjZ
iHbxCVxWYOD1u9kfT/I+TSHhBAKJqRjGGxI5oEzoaGWNH/TPHwirjL8dYJpyg5B8G+r/VSW/
vGsYTwykwD7m0ZSFBTpOk8JnHljqVpwWaJpUD8G5xjIZYZcxjLVxaJOami6KHXFHioGamgXQ
42g7QZjtx8T1Gd+LxLlDirGIZtkcdk8cZpP6fkQ0tCO5VRTEt5MGr0r+cMa37Qy+3dy1xV9X
IUSo+68JzHqXfBx5wcl0mD5AzY7EktfEJkBHNsuGoP1TxJA40Vc0HWjdsjnv2lOfZObfdJ1i
5UrduhdCTJUThbKDlU0F+h0HYW79S0gvcyX8D4GbptGxxEovjMy5cAhKv9YznDgkxCBnLGgO
N6BsKKtptngR1+4TaPdmJYZXUK9CHHwOXkjd/wW+9qai1/MSEr4AHZ59OYqg2oUdQPpjgi4p
e1CJEr/sJTIOPv65IWwfdi9IeBHNi3wfBGOby93/3FyBsPcS8pNmA1aylKxBDkpG7ah6Dke2
9lLBaLdQCekiMH5mHDrDUmKZgEDHMTxY9szKu+IBXvzNoxyzybFRZzBM2eCoYQuToiFMbRW5
0Uu4VeGZwXFvzXvBURewZW2VVz5KmNMx4uy/eA8sEl3oanDetOKKkLCbXIsurlchsu58FdZi
cDcHk6BmpXATVI84HDsvNDxYsnYGlxhn1lXJ+wcxwmalJaTeN/QwA2Yvs0ENph282OchtDxv
uHWC1eEoYbxEHEvJ6d2o/HA3OdiT8xFnZ4q6hrx9PH2DxNQQszuzDSDw4KUvLcKpHSuMLyHm
cllQL2TMqQIvUx2YphvUwvl4ODbpKtjm1HZQZVJkrtIdzLS91jhUckG1ojFv1JZ0zPeLhdny
adcwIHcfpvHGcAjKqacHWFyFQMXSD6Qn6LC+ikzpr6Yg+p46jMTIL9J/G1WXPm/oAEciYsaZ
xQb1UE821jV2M2AmngROflPvVK7afTbXyJ87iyqWUfKGPnsZS1L4+ig6Aih0AoDMmLo1TjHh
qEG1qs9lcl3tYYoWnoOkcc61J54T6BRuVX7fqFTBp2LxeWKMSwWqttRzTSpfaxWmYp34Ucmn
AswwHLxEWMEBIInc6LWd+XKG+nu+DwAi+U+d+Esu/ayNAt7kUIgoxay+cMDt3EgnGWW+T6pu
R7l6dafpwnGtcp6j1sl1JoHXDLsDGZKTUi5iemkmZSTDT4BBZnz5uywa5azorsQJYY1EdVK7
whKeI30iDU6Dz53fwQPQDnSQAGidgNmmdAaBBwjAX6feKTs8DKBgKiAq/kjB2fgII7IM35NC
nRttMu1H8aG1wf/uteSxk7/SD+Sr3WjewRXlbT+29YM7cKIEKNATYRvf8oh90QdGNHiGi+m0
5ALDpXXTqZi9Kwg1otIvaZf+CY3a6veWqgZL0SCmaDCQcOMmbNX1wtsa1n9/YTjekOjB+24u
TbhoEdsHe4bga07OJUEQSXz6KXnhmP0OUowhtMgKZyiaG3ta9DVeGMuElkMMlSwRaabVb6gY
Eq4QLtDHgUQi2qOcNcEUDZ6LRucVMNvuuKuW5G/N8hx4JXOocJg9YMDOscsZNbtAER6QKpaM
OCTl54z9201Zi69A/m3Dj6BVhI5Bb1NFI7ZPqOjRHPXR80rGnIyfsCIVAQbcEleXWWICYIJI
GM/BwR89slG/fyBo525VWMPDqYAMAUy2iiVQyPwpSl+AcGKu2dYjaXESY1K5oKCCNXChS0HG
CnIKMFhohyRW6k4BiEiFaMsq6kJzgocaCUkWE7t3V47o6CTnEn940GjYsqwRBCsloyrQYUcZ
/qzM+C51sQhOkc3tT0dIKxnkbwjhbTrATEr73UiyMPcedeoIPzPLhf1Bgvo4adyVQXyCDrEk
jDv7Vwnzg02nkVz/UFbEOG0h/DL7cKNnoMSggW+BaevZ39LY+7SpN4y7MtgR0TEPSD0Iuen9
6LK66VQQPAmWfUAVHWigfcqvMcObh3YppSlI6XWF4+dp0DNNpMuvcFgV1Bbqgdw/tDCT2gWH
PP/RnA1qi5+/mZfEN/sLm7LHJKIQAtUb4KpgOGxD686b+X/8U7vqCovpwXkaPi1DKcsq/3Bz
+uOOgM06nnDI10pivqfNImEAg0f0q/9l7Ii8eUC0TF0HgHVqfe/AjrK97zjt1fmfkHCABHko
Jgy2q0IE6VXTVMhl6ny/zTh09SITYdi/dlEOTj8E1Jd0EjQfdG/pqbPvAST1WQKXAufP55Ww
zuUARcoiHVOYCEuqiCqENwhnKC2yNC9URjQOaSUGJHrl/M3oW3NreH10Mgd7QvS42PAEEKD+
ESgn2JPf9xpdcqwH5pcxcUEYjf0qCeShjOxIsqBK2GpogmPF4v6wd+rvzUaRe5ej3B4tDOgh
O8k9iIIdQGrLfgIFXVh8Aof8BLeby7QZelzmuCJlf8H/BkJd5dQZCEF8m9oR0/gbMNhBPL45
GEvyrAxKY/Fd9+v0Xp2Icl4SoZBwib92tRfSu8qC7yO/48cVrbvjtmY0j/gO/hmIuDyDjmLe
bGJJGkV1IUIft3epbjOaSMjLaq1DxffiXcPTyZTEoqTmmwXgfUYKUv9iM+XhYe7lNLdf7eKp
8FPREvFeXmehcV64DS3qb1DT6qd6xzC5+vWJNE//miyHjA/GHM82LS7AnVSqM0EwCjoQwvmp
lSD6fs0Qo/+voNh0XqhaVQGq+2DFU+svKK5785lfFDjBhrAo+kcTZCQU2T3UxmYDg7CRt7Pm
VSZsaS7149/4EbH+L64vD8tqK+TLRn2wnM3cmaRktJKdVQYdhWmbFEbQ+sfkBNuvQ31RLA21
YOS9QNdtS/3hcDp0oIQ4/9OiaGNt9l7n8s6fL/NhSy2UFgdsDlD6nBl1ZoEReSKFa2BdRHMi
59pN1p62KqmvSBsVEiuNNAoOCfyjam0AjopLDjmoDgbZBhw1yVmvpbKW2aALFWxoSs7AgqVm
8aGPvpwFJ0NQPJc4vivSWvK6a5ZYqXYsBgSwFJBJyqjj7Jo6CeMf7nlynEKEoaiSQBikLL2R
k66JLhRCwhhkwf5tOnSQLAhqxb70JHKfgJBCg9iMUyvzwVx3HAJ/RSmgS42DfFz1UWwCp9vO
RlRhZ7lTVWlS6CWHG+xz/wHEH/5mdBzbyuQGmcR0DVOgQsBtT5t0xIRSBur8aeRl5pqs3EnU
GYE76+aV86dX9Tl5FGdJpdqiWw4tV6f9OMwt3XiXoDIapyQaqSEeyHN8xfnSjw6XXMgr5l7u
aeVnu+hhnuZCR/g+oqmYeLPAGP476O90Zemh1pNUlxUOPTjlfMIsERfjgzVFPI++QEzmNq9z
651G13cqexIH7sPkR/jwEzrlJiFOBjiVJgbm41hReUZ7UwGU+uTqeaSEoidhYBTFCqLGLqug
PdvRI2jxTc0vs+d42mdBRjGVx7sRZQjerZNJCGZYVXAHFVzehr3JGJfzUxidVBumBWQ6DiCA
LDD43ZUw9Cu4kFaCrm1+dc0cezbW3PggqIv8hvlDEbihOVao8i/pr9p3fBkSzrgMmKazyYVL
MOrLArT85lW4mzkpnErgfVN8yIdhrMy4fVybKCC+rjAEFYzsmcjRJ27SSOfKQUVcnhmbjYdX
XJfLavWDXi6teMcbd5gM3bIjkrgkukKGMfD+9yeQc8JFFIFWITtao6DQRY5fYMz40tN5bty4
7NTGm3J25CdVtJZo0+bucHUCLFraU2x9dsvTOvTkMGrJg4R2a2ukAm5PJOOc30aZ/YR6kiVE
wR/YWI0LLXhZCtwOeWGKGecs85hUv8lUUw/Osh8ibUMd0x4MS3DlWqDCo06IBfzqbDi+Qb5V
L1LcsE7+mO8Ekcq11OPHbw4MhurGdoeiYn2mpC1bmuB2pQdon9+VDnF4+S5S43QX0OlELU2T
q21d2TuUjYkTuELPrBNxx3qQI8TZOu2xe1WyCT6MBQs8QEkFG7RENaJVs5kUSQUVlna89f7n
Ye3J+e9/R/hFJGMoTDWjnKozGBXtstCPOnTIMf0b2dD6wAdJLVfUAAkgqXejMrjiiu7JNBwf
jSp+ONqRGxKH7eK6jPLWg5YGIDStLCBHB4F08b3vlhJgmGdbukkb7hPv1Ld3V63wjttqrur6
8yL3S28nqRhhzB1xDlyTyHkwDJWxmwVWy775Gca9tV0vXVFTpPVxIXdvSdtcmMEEilA4+aWB
6ewkfltmWFPF089Cy3rpem5YoWWbfnXvq79CHwNd370UOQMhsi7fsroTRLzEJVkW2Drc6O+Z
IFhtHMAHipjYRT2twEFJV/KZLo5NItID2zLEtHcOIl1pykJaRY0xBo7edafmxzaXdHMUf9eM
Hv/TI/d4DEToF16O69vmbxn67HzY+fM98T691GN8HRF3yjV+Ae7wlSMS9kVl7U9TPODdb7eN
wwSHQdRw4YM1biEDZbQTtorXvTOLNrmLNneJyk6WoRedi7GhVvKlfDETH4mCllQANNCx+nPg
e4ec6OwFwsulk4Az3/sSE6ntLt0ZG3AgtkvEvbQFNop54TPf+xJWgwU2innhM9/7EhOp7S7d
GRtwILZLxL20BTaKeeEz3/sSE6ntLt0ZG3AgtkvEvXy0Nn6ErwF4mWkN5JLKf7r47op0OaRw
2QjLq4H7NREj/Y0uDKr1Umnsjt69ajnu2q0Wo2IhLD953WBkYXWaq0eddGDeCX5K2J1IMMBN
BCsrjC0f75EeCvf1HU0Pfwp+GO/vXIraLnrqf+tPH9hNOaBDxYuVGUNvRGprfAfWSzHLeyN1
Yf/dP0ZXixHzCEGXakaHD254q0ZWX54NTXgRafeoBKCGDxW/Q0A9zcQVBpTziO7mkuOULjdP
L2XKe+hkFzuf9NwHVPZ18esuUDHGLlWmKf+Gp3ScXH8csGEXqJdWDNGN0IyP8kYhdvWD7x9R
jVUXA4c0vRIwM/J3zUCzrV36OkQjRKlx/EFEzcuRdeoIfBeXk+kBhsHDRoLyrlbAPlmFk0sB
fzQD6UAsANMeHkNcjq5gnG9SQcUVV1Dv/okDAmpZ1lJqTia0Wuf5GRPcQ3o7aQugZip5ZfEd
qCYTxjVmlCdf8XxaG5LINSMrgXotrmlrp7NvHKenRp69OXrT96AAJznWnjf0DLHDq3EuqP3e
2N6LXZ4qjdwMSz1znB0TXE0mElSsO7lydrTyAuxCZAx5JiHjbYFgOpH3cGM5nxsjcPwKcWvo
JYnldLoZ+b5LkwLsSqUayWekgu+wuePDVlbDoRLFUsB19QQjGDogojh7zRtKNeoggQt2m2EA
RUa7ahgVBOyjODZg5+YMsfLFfqY3OinxypEcXnbVEwvv9khBCytspK3GdW02k7F54kvoe/1S
vvzhbNGHpI6eedtecMvfnUVLgD2twxd812zUXPefRZcGCml0/vvzyCOVL1Y36WfeOCaWc89u
j+IEoML3kxeN0CXX1FcSoz0wKVBcAQIx5gStnlXyxQIxPn6P0fVnXRUpjnUEsqR0Y3yk0DR1
V0Pt1FeSMYI4/fF+ImBt9mAcXcBxiA5Oe3zPiN4Ug2Ww6GWwk4hU6Xk14nRP6BZym3oAaZOn
umL86LbUgIdvk+p+TdALTLD68UbnckICAn2XQBUzfZoJirt6BGkEVQIW73ciRKj9q0iDkPk6
vm+JoPzdR9X+em+jbjhjs+dPHR9gzCSsiEhgeXZqXmyEB5ZBnU3CHKyuAosHmX5KSx9i9jbD
e/Fv+/G9oQGOMPKIcNqs3MZpOUhkvj+9XCIt/bitYW6OInGd+9gPO69PJ9e1LJ2Lxj97vaBT
hLe+11CAP5++BHDkRY7RjCUc07lvk0Je6LIwD9elrORykTc4SQRn0l519lCxalH79BUxKI+W
hQA3I5ty5UC0xgS2FqKmEeO/lpQV0o0qCNu2IwhJuw4/piTwVtvflArxcRghmL20OzPslPul
LO1q7+Ouzvw9CtYdnaNzm5UkMwEuM5yW0xT1O+URNypKSsvlDcHIOSXGpTSy+7zPSsvydLMK
8+NZ0/+WmT8W2Ief4R0+3RJXMmfKeK2bhesCr2DYZ47d+2AUeDmzyEmUQHWYyZP7vKn2kJ/C
ivJRNqzq4zYOOY+9E13Y7q3pvw8iR8kvGD97nU5v2ToywE5LWTTyZZgme/q5CIlSPhday4hk
Vc1AO99wUbvtxtF8IczsfBxG5zK473EbtSNaKx6eiX8TWc4ZZhxyH3/8J3q+qDwvxl65zC48
6iYkbTANHGQsK1gAAruGqM68XnkRdNKr3nmDInrA4k9WnE5jVCwkwOF8D0qGPZ3osU4TFETd
AMXh4Q1CljepgD23NFxn1Z8GE5lxy+58SP42XdhSburwmnkqUhc92+2Mo7VYUcltoRhShSf5
6AyrCnr7IJg5XQi6OxzTuyN6kOGbx1dadP6lSAQPtXu8DEqydQzHBT865pjs86hgcU0n8lEA
IeZ+8j5UbsdumwKivBchSVUmQV2Y5aiI46PducH7ZqMb3Szl7MO2k+cr1YUMIwBPVVm4Wggx
z81VSZOrlgZA6QqJyo5+8cV6KUM38vqoWQpCaV4Kpc6sA4QVX20XQq1MDsJ13X+g74UUd4CA
IJiUW8gxCqSH8/MBn0W4kMZ6FqOuk6uEKvPng3DDH9Xk20SbsRFWm6mznmaJ5+5KyDaoKJ4K
yhWhiBs5FijcKzW5L0HbR1Z8nYSTRPPDUL6eGbLpaSU3GXJvYpCm3OkpJeK0qjmWunOspVTp
dCvgy6WNgmcFZ30NlNhUei6s3Gc+C5Zl4Ijy3wbThom+cZjvzUzCSknZdV2OooA/emAa+IYU
Oo6ajIZkU7cUnMYJZyRYs/Fp/A3Bche82pwyjTB4x1mEJPAX9iBzqGve86g1Zs+6bAo9NjDj
/ihdgSfkf74xFq2wALVJoLNBO7aFKgA6dTDzKf+w+pKEgw0I9WWLgmYYXsPCrhUQQGwdyc5c
TpEU7oiy7LOc1TsGyg8cSZINaxTqBAjTuFdt9ZIN5kVEvFsLQFpfDxfSkz7FzGixevMrngyR
jRwZq3Xhs89iqGWEUtXmUJWAWSrmgJJsyCua2SWfwjqWkJ5e8qFDzCvisUngvAP5AZYT87Ob
1UNP4+AEUsVzry14XZ+ZrzhfND4eG1nTomrGugif+XyYJvjPxCM74T68YNlyyEsQjRQZNrvg
9VLs2DRSRVhSP31+CvgFMX+Xf8ieWYPzpw/1rKgxsn2rR55cZeg3kTnKDyfh/amaS2TkkNyH
VlgIPOK3UhnUbV14otseZ9mwhj2r67tdG+/8GaSj3Cia9Jfco2Hxiz9ZC0sk1+w9sE2UG5hF
kCpGiaVHoxYEoMyBiwGON7OPcmRSqrNq1AowpZln1Nd2eva4gUMm6JGOGrqIUsNF4nax0BSv
9qgGo180p1Fk6ed+f54K7y1kRMkrYtHNmLGXK110rVIlEq4DokpJVT+tYTR27W/zX12wrG/L
hIP7Yt60dcUWRj3P5xj9GZdk7L3CogKXcAGINFbjWAH3A8o/b2DMv7xHkHiGxRHck9q6Grru
VcKAm6/FwqHReEoTXZ/kfEweSBy3/Z314IEAJ6p5d4sSbTL0fWB2dBmHsgvlj6WVEweCr3lj
BNPNQIu5wGSBiykchAuvBVsP+6f6pEWydheYLu5LKtoMM2eG4hvkmfCOmdq+hQcOYHuVnAuu
rormda1yYvgPvNI61wngAMAFOFGkaG7JBLp5b3qTYWI4ZpnJnLYelETbhmMuHnRqs01V2izs
opdgOD6vxDjz9MDRVjtnWDGcreE4QzubXWKht5nZ8TKtUS3lrNFaltOVl6tCO8WRjQNo1WUw
Xr0ZtNciCnFEk1QSOcRHOCSC5AS8HbGBgpuJ1U0E3bi9ldoITdp87NR9YxWsrSrVeDRnxJoD
nxc2oSABToh+5wZyICAQLeTp+ORR1vnwQL5DlhUOlGAIXBL1NRMtnOqJOW/O/+H2srAD8jwe
+opIXCujeSdQz+rueFwy2Tvo2KStQ2cjHQmN/eMEN0O0HggjwC4o/thxrYeuj5sJ+dHrDD3C
lqn5aBA+AYpUNTgLAURiaHZVD4fbbVbzjUr8bgek+jMm4r4PQ0R13RM9bUupGkC2+IAY8hrO
Kq6QghtqR8iv00I59FTUnYmjaiWch/QxURP0Dra+d5FT1LmWXx7gasH1275TEHOovvmURpiv
0uvOTpcSVGzS0Y2b2NUonKHyh4dUjx/Jk3Tq3+YHzrb0ohLMgS7Ts3sbIz7wdLrqfIwQ4Qze
7HRCpXbA41AM0wTabdvhlSf1KVS4YiI7AZWUeb7K+3KXPhd/y2+3s1/YGlEIG6jeMV77TRrr
6Oaf3NDUslkiqbgoRiYumfbOP4NViaTq8snBfw8JRbSL6/gmK3AZMbPpcOW+503wp52yVOCR
6uQIz3+o13IfcDYDUaBGF+FOSV+l+wMpxdGqpeu031Y0svVekSn/ktJwBsP713BNhdXnvrL8
Yorp69BFr4UeoKq9ALW1+CbiozLwfFJgS/Uzh5SDb+BDrUlm0x+vcCzoJHBELBQgTWQMSrom
YqLar4OKDYBZgIwOeDZbqRh83ey1tT1z7Ls6PeX6frJtJHQXZSL8foaqXlJ+7ScTjTwBULNv
aSzgQ6xQ46MaB99mHg4B6REe7f/IzEs1L6jiERQW/vX2r5ftM2t7saQhK6IVzqEvyq2oSbSl
SBhrY7j171ZiB7BoVKTIDRRFi+/YvP1c+HqICN8ox748vNrSc5uVWze3vd2xzYh4zGjUBh8K
ULmsGOOkucs/sdIPHEN4VzZWTLSbocrE0gCKSb6uNjKNrT70RYydcwdwlv19eOlwTJafQGrY
LbuZ8JPE3QehZ0N+n45+y/xTKH3ij4MIsjlwpOfSNzNuMvpQTIVwmzuYmRCPRW2YGvWcV0wQ
BUoz0Zg4d0jgCFRQNnxxxD2cfeWxX3LvIZ2ahnDjiKNOpCRO0rP+rfh9hHccge+8xoqTnswM
xAeHZ5pekDRYuKvCaVIxiYkeAO2nXswMIy6/zGdI0T5LDGbohnJOB4FvAvM5KfRoSn+csfV6
mBIEmjdIgW6+Q6sM0B9tdQqoe7Wr9szNNtcgG1q1Al0+J5WVe/nIXyDxAc/aTzte58EOIVkq
WRcQ7B76aDQ2ASo6miMWajOaaGtxcrC05itE64q/V5ED3UIkvPlcKMEhEfkJpv/PvaoiLkg8
LI5ac+N97qOMbeFL0u1mS5v4RFLYKtVgjXTRHo01LyvV1siYK4g2UlaI58ZSESu9arhx7+GE
xOY2GB6Spbj17T6g34Ype4f/JCmmRJDMdoFkWciJd8+fI0V/7QN4s9v6gzTXhd68enhNTsxO
9sqE3ihbkI9MXxftiz6wA/Vu6Mb1P3RN65JNrmQbq8uHqlsVxDlWSiwjsEUF/Xtwrj0dKyLH
Klam34E7Csn9GiOSMVR/AIha25WxJUI42DnMWlGHUO7AZqavMM1e6m0h1XAneKy2G86LSI/I
2aBy9aiNsyv2y22252IrlW9/W9udnFCsDfBiAVd2rFrRfzXVyqAvTbLuMUIoF+qOuNAitt3F
eJ8jukm/UVP9dKp/VSVieNIV/k4lxE6sv8dIVL6/wAXwbhIamFi6uUOSHMPXA+BT8G3QfQBu
HdEFSeEjCHkMhY3gtsetsJNRS+DcTqP4pWmVYq7p4jPIDANCvagkGTW8wevZn7CU/lvv+uUY
i4/118Y3p8HA9bPQg6qMV3c055gm/sN/ZwZx5/IR+EaNEajP2uOFO+U4fjiCUwdgUwdcfPs/
sDFV+ZiRQwrji/6LvMudUJe83iio1Ldfhx+MSAcebYHAxn74L0PANMEpSqh+/IrgMISexW+x
pJUGq088GSnaOqZyneB7h5ZMU42QUj7SimsHjAWeAd+b6XmGpHkGDWGlpPBiesEDqG+OeSZi
9vXXLiAxbEV1aBB1UaoekDsJYQNSJyC5EuxbNSNfZ2Cv56wN46I3m/N78muqxS+/yZdYf/gq
KTifoQaaIWrcxqUhCo/yHHW+WG/4FvK+7w6UWwHHcPuYRsL8LQjsanSaad+KRONIYXxs/+PR
760xcbJqnYdA7cl10LMson5WbXcXtyl7k7l/I9Cz4WC2oBb0/wZRwYybYgfWAQjO9VhfqlWU
b09gOKUMe/wEfEgwMS4oXlry1pnK4jrXvos+nAoiEsVLaVWfruoo4Q0ph4929tTB4xKI97GK
PaoZQrVBa4RCQIo/CKaf2U4xyyYLv7itnjAjWmNa7HjNb0UJDXKDOBS8b704M26dKPyP86zF
wpu+CcscSha7fO1SbEpVr7FnvNcwWr3vl1E8OsD5S6UZqtF57OJSQzUaznr8D1ETM9ouzu+Z
xWWRWQqwRum8yOioKwvj68a8aZHTQQ3cOuuknR2h0xLQCObYwFDK+de0yOpESkMXYZJ2wm2W
qWmMW9QtdifUwBGI2Ws/Vs+N1oQFVMsNC60h8ENpHNlrQlauKgtCJ4jZXnNUzsVbrnkLQuWk
2V7rVEGXC0InHNn3yVaApy12KcYV6q1XwvBDWtqn7+tUSl0tdljGm1mCpxenLXrr0AJkwKVH
36cXgy16gvBDWHqnF4sterFfQ74BVnKBC+4KdnrE8EO+n1ZyLgtC0dBDvkJWliELQjiI2Zlz
VM7FW5Z+C0JrpNmZ61SHhQtCOBzZDNdUh6PUmwkkb7yXrwwFVIcnxpslIaecm1SHlwuIyeHF
WRUI/ivanjEmCwq4TStXoCsw5SswJzu4GitXwisw6CswyTulcTulaPpE039pwbOP0pBd+5N3
t7NV0H9P0MLACb/dppWJ+8L9XecIGZGQKlvG/o0EA58bfnw6Vw8gWB39oJrSgGwxZDXlJBTT
9zWkHQtHBDRJUZmkIGAOZS5lt3Aoap2s0QfNeuETJrLrZGZSTczWhJLj/NVsFnbeL9045Q53
XWRmcbvRmBtjB6QxWyCsTsfoAFD2sh17NzYIMR+Mp0QgqSMIzpbgc+H3cNsYYWJjOxhJkggG
hs65uS2kpECBqPReN7g3P28rEyILw7CK7HSM97M6Gz1d+RfY+ie+P4ryUwgUMB309SiemGso
aFVQze/HqI+ZYHp4Dhk+yBUamCqTYuiGcoeqLTf11HB2QoRwxiYLJj2obtSFpq0FTSR8+KyZ
+yp+vI8nNbeWU3pYCihOrlIbWpQ1k1v3RLm4/Vsffe+/FsAx5ozzIXaeZ/h1iefvizXeUfe0
1AHFuXshJwy9UvN9I+6zJnDHzR5oh7p0pWGr4QJfuiyr9CiMGmApJJYfY0/bhi3UGZwYfeEe
DOn1f06UFichz2xJ19RSuQJgzaiKlFPbaE4h2SmeAmLuyHelgfLY75OQGpbd6W/Tx8EtrM1O
5ztlmjWEr6BaaIrwzhvVrgpJRW56y7Mpu2GI2oq66fhCkZ4qsjyu7ESCNPNR171EGpTxD5ke
8e0UZHi9T1ZG3BkWuZ3TT4uYGHMPVpK1OsDAA9m0tZNkiWeQJ3X/IQvKYEGLPB3vXtNKzdcH
wgE49LRuAmbHb1/ZKXaNtp4lBFIzjqYTbPu0SMrcTATc9i/cbDbB3NZVm/utlWfEmlfvqckf
KSQ/W/e7v40ij0iwKR3bpXBCgv/pUQshKS6ktu/JcpiEq4vpKnP9dPZ97bMvreJk43A0JhM2
y5ULPZRf6pyUllpvjCM3MAhTQDQUolhVSDpowiTAr91kH6gZNBJ0FAkZoiPLgHskd4XUAQYw
CxzgAxYZg1cZbFRGwq80VZMCLuZCH8uLTGZuv2upGRp839kdzeZ3uTmz2i6mu1GoNHK/BBUF
jtvaeF/E38jEQpEnWbu1m3iKxATBuvRrtRBSufjXOkx+3CL5Ax3QtRAIOp0KVcVAQ+qI6bBT
WM7RFdmupeldbbCZvz6nVSF3Y1zjgXxYGXCe1hA07f5P7R4pBAa8CaHp+DTkfvyiIrzBmWwU
3nbFUt3tJB6Ah/2AVNzNox6iAwTz12YyRjzU0Jf4rxEEoavyV7K6+vx7WFVZyb8iMhf2Amro
D1P7Bk5vDuUmjBO0b/1ELzdr1wyW5bbaCDN8KpRkLRcTWTdIIud3Vdfy/44p7GT0VRXrY/ax
uFRp2Tlk3kWCY0RmsmnATSEM5Rgtx4TMKn8mw6UwoQoNEtf/AZmv1IsFEUUU6p5MpAF+l4Fk
m7An9wgBHzUS6QFf5I1Qh41Y4hdcA4Bh5eQqBI3HzLyEDRhLmjZrf1HMeq0GmilFr26TGqRH
ao/8MpJzryjc4UH6pOB0C9MKhnMXIxigHkfoi3UiyN70i2wp77VuScQULwNaBXhXwDVy5Z8Y
UWJB5GHeuc3qo34ubHZ8Wcz2Cyr1xqebdIvoQOhU4ByOh2svZ7stNMnQADhMFMJfHnDAWhg3
Mj1DcC9gjWHmfPOCwYRRaa2YnGBOZgA6t7FLToT1vYG6jyQX9J5W/+qjp6yg4PYSq0Xh9dk1
Kj2hyb99G9VSTxSBtpjxRu1Os0T09Kj+LaNiqgz7XQOsb/fM6aIA1tnnNJ8JY94GX/F0xZ+k
G0GlKmglN4igc2GJcGEyBZ+jfLBhn7erVnJ1AR/FP96Y5sIJqCC0viogdSL2BGD3EP9LIHWC
R5XhG3KmG5ZMVIfCS3ljnsdZjsmutsmu04unZthUrHwS3vOBXxvmGPA9K7dKPo6H65nq7xqu
2fp7a7BCJzi/iiZChUtHzpqCmVjC85Fqa35cxODYoCrWjDSR0g+C8Oxm+rGwCQte3kcK6HLY
1D2CGpPVdRHXfz2rDg2Wh8LZTWSZPmRtGrr4YL2x3zyoDGDfnmw+kKwub0GqAyF+Q9Mt+oIB
LtQbHjqKvTGJmWjE8peLQ7gOcWjUrPQxaF4DlKH/KxYAuq82eUReoJShJYtB6DvJ7RwGxSnr
oBSd7KdZF93fpUL/5HWHkwIQEwfIBZefG0AEv055IckoPuyBir/xXPwFSYmD3tE+sHoRAsBA
iVmuSzjfIXKUUqSCUUPgIKHkVS/WndzJoCVNNHOKETpXkNA9YXbemlsnwZHyTrw1tZ6LDMcx
qunA6HP4TxxswLDNBuc+9yR5jMcUeG2DeAVSAcAmlIT2sM8nnUlH0fHqecSFTBTEg6elBW44
zdpnCBVCPN/XoGHMK+XCMTzf18RhbdzBi3HVT/72H1VV8osNu/Za/zqxvGRI2gE42ddqi0H0
eRO+tJ+Q8M0KXQu3lWxEx8KU15cr0Wqrx+wF3KcNeUOTBYfoDc1DowVIYQ3Ni7oFYNQNeV1x
Bdw8Dc1dTAWHiw3NQ4cFyTMNbuT2D2wdBUrHS776da0LhqvHZxGbGKHsu+MAtuEXsQiO6xQd
MqAbTJJE3E5N/2ydN7GKuo2ubYTZm6/+7OR4bjH7LGqbauxuDkeo07/sL9j8syhQgqvAZCbZ
bzzYCyKizxRgvUkdxhFyvExGcKD7DwOJ9i9PA5NJ84xEeb0yRqY5Kos8Ha7K4GX5b+B4+4Nn
wyyizSKDpruR6vMx7oTAFbhSDVD4Wn1ujo+IK4bnJpR6ctsceQbCadTMa6kSrK9wnYwy8ri/
6RbBqWlQzQ5LAzU4H9bhSkST0ZkBHZi4RQIJ5kPxrtOW+R4vzGGwgqsVfRjZQON/pqBJvISJ
wW8qpOjZ4PFozH/L35gpGEjshJd5iGrEOLeeaMp9F+wLSdocbJt0frZHWmSNi0WvQkkpF3k8
Z2z3KDcTAI66S0nONxo3cDetdBKE0l3wqLOu0fk4+QRHdK2dhtO+nxiRBT6nIAfQ3KxMyWWu
qyuuFLx0FwIqMjUFrL1Rn4lml7I4rduX6Tx0NyERXi+TTUQenaTCBC1GdIX3S5T6mKC3Rwz9
uDM5SK7GL29SXg2PnguLJ98raeZjTaUtH74sEszz3JbAsheKhYqUcNKef0ICBHoBXzkoopxV
j0FllzQfrJiYAcB4h0mYaCg1EHe7v2DN+yyJ7dTBZBsPosKIdy2U+UI2yayM+Rbd9zEDc8I6
HKnhrzq+xd/5eFU2Ne4uL1MgrA6FG+cYfqxnpO94fpyQfG9LV6p456y5sj+b/rErZqofSnNM
V5LEJ6l+9Kbiq8oFUakKOYVjZjec9ERIBI1/HFM4cIt1j0oLx22Zh8VlU3vbaH2P/BZO70bB
KKC4iaVoZ4++RAm7YP517kNojRUczWGOgnG4XyFgdJ2erobD6AXGjAiOt5zDST7bDfLvJxIn
3gx9uC7e8hqCsdMqoMRQjRaeGVJBqs9Sr2It/Agi9Gx6E6uWQnIbljJR5njeU9fVQIJpRNGN
gcyjRjpMCEoQQMXe9/U2MZjJdp9bjL/e9LfYLEa/SzPWjn8dY2wEUFk1SDaXlH9q154B/xdz
1ZDsEFCI1HkhTMGRunhT4oXqZ1uurhn+PIouo90Xw0CVzZxInTIxvUS1K67An3bssRvV4EHp
K0Aq0EvFXyM1GAlUdQszfZFjk+dEcRlp7EqAnx8qQm35bDD91uYL50YLMEKDedBHYy3ookzk
RwvSpZVOHwkIBOQR10oNkSZSWy8ufGT8reWO9fwg7GmKadvSVJ54F4okPjtf5rp7bORuu2tV
fAZemyKH1yynsaE0Qca1cZS4v5HbqhMh/4rfWCNW+hyJRUz7cjJ9xXofLwOLMh5l0+bepOXe
z4KTwRR4LhDB0hImyWgqKtfLJogzNy8iWIIrUjLnQyDWU/7Mt2EA0kWsIO97r9VE4S+3TS7e
UtEVcYfhSXIBpkRf5Wn2KS79gElB/5rQsBmmR7hxkqm7AWD9XIispd2LPtXXqbPBXDiT0if/
jqwzRzCQqJjiPdydWMmcQNIsEUplFuDbo2qN0EbzX9t8rMrbff4vNYXLEcVERxkae/iK9HFm
DUSFWhEzYjvX+lsmQXpedYSIc8UMUfGO/i2KRGrBbKy5+x5HdUzFw0yjYm0jieWrgwCa68P3
4RMpUulX8Ur0Gu9z0QIA6fUiBovTxDTcue2XMC113OJS8nkgvNJvESRCtjAdp/JcmhyN8npD
aSil5nFKg5B7ztTo34mpgTgCYZbGIGWk9VAAbyD0/UnLYUBqg+c7IC/qslUcKuuCFLmDrycq
vhNVSQMN6jpXQSIUh5tkBwj1Q/eGsf1ksdn6+AcyCL5RsnvcByWQZN94SvN1lhe3+JUhN+Js
/el7sB/HZzI3hX+HeBENZeAUTABbFRA2DEfCWyq+VnLZAQG9EPHZm2526qfuoN/lnIRH6Oll
TtTZQ87HOq0SFEfMG1xqH5qedaIInI/sI6tclfuReDz1DIZCxny+tylknDjS4uAiz1vo+PtB
Io2CwjVlaGXNmVasfHEmf+eS/6OauIS25JfNL3T+IHSvyCsrqzUhdibE4N1vN14kwer0XMKs
uWanjo2II+lnsI3YyLL+rnoRYiTNNlk0QRjdohtoOcvVOE3pwQEgXd8n4gkgFEhugHqwVblG
aIspN61b5cM4EwrlQFY9vZVj1nHccK+9xG4l6uNYXpE/0CatEXBfVl64fBo8+zVMKpBHxI10
IWHx8isGbczE77RGm1WhshvWexSWSXLX9vaYgvNig1B17VeaPRUDEmreiWmQaEbEG5DDSUlu
LWDpKl+Wgzsr47uh7b4gZDwb/1lGrp12QDvOTCiQH7CczdzVuShg8XZ0M2BMI5PVHGir111D
fVEsDbVgTKsTHzicaMAO+2rZCbL01F5meQptlnhGT2tIhAJy7WijggdhycsM34RSNQC94+N2
dA9WFpWKcMN77n19ll7pAieIwnmR5oR/41joNve27G3uHqaAbkeIFqA+BHfLDO3ZSkRTG3/3
ytqrJwm9RS1bc6iHkbxwFGmKJ1yC7NI/7yjjrota4bng7KRcRlENYDvMO/HI4GTk7Kqp+ZBR
qhd9D8ZkSPbyJXWHBt3e1LN5WUdIF+gCyYxt+e2EtdGfANUvAzi/x1GZ+NjryGDTZFD0Df4S
xz+2EOLaBfVDuRdCxVCGTM3FxindEFA90KwzfMPB5bF7CDR2mwdSK+CnWWvb17feLN2clj/k
OBAk6cQlFqKRNL1EkTkuq8cY+1xVS8Ma4P6RZrFluL6R0J5f0Xus8dD6fu2X874Wijsq38vB
o9bHyF+s434N7AsNhE1AOVxNJV4ZiPRH6PY977GscnGZIr9izhUNjwyxrGRwHKxv7uBQc57B
F/XYaFfdgtAQF3EKjypIOaSghzWio2ru+COvEzOtydpMqKRFb9sM8HkByn7W9mKxXEhT4sCG
QtdS7yGHSxwPAu6WL3MVLQbZIVcCqBYCJhkKfhhNN2O6lYRf+6J3UjfiKeI9fG+pBO/P1lQZ
OF9KI6ASmr4rxtq8Er2kzUZSsFWZPsrqpq5MmUXgr+6Ct+D6cz9ZMhi1n7ELXte7wRktMhkP
eld2Oo4poH+CSJrAkTEIHlfFuTT5IoCJwDlKhjhf23g42A3HjAvcRBtKmsd7jUpgjAufE7Gw
gPpWQQ7LSS6UDWLTEUd6/CEb0FaC+tdRnLe2tDzVjSnB9NNY64r6LDDwE6He9Y00/kCitect
Guoomee4bmgwt1icX5zrocLSIhsMhQq8rE19UJ3A/GxLWZd7F4IMVUqh02FgXHRZMvp6UUsF
gFsZpWSkW4LDSYbrJd+wDzFIIcb1d3AqkxW4wAphtwHXSev0xufukZ7jgfFx0ccu8DkgJoB/
vRWuj1YUp3ZmNkMVfbIGtkI76BxLr0YtU5SMEYVNLW/kn5/PJZG3/pvPPDQKRTibIb/zpRaB
WTeIjW81q3zhtT47pLIc/VqzZ9NdZPHewO0z+X1V0cH+VgW0qHt5f0ZTqj3v4l9o6n7DzMYB
68EmtQszO5c3FYp/J3xT2637NK4s8QEGzKYGDGbMcuXJQtlUeael2bWb6V6mhE1v7Faif9de
lSucisTmqa96liLNxBmzingv5Dargg0Cs7hQvqLnnDF0qKsCFns5lAKEhY3wnEjd7cobqSTZ
EDv8Hd8VlGKeteUsXkqkTaxoe+DMgl5A7FmdnuwyZZj/Cj/S2bip/wF1ifOBH0b6geKJw8oS
Hv+7VUVex480KxYaE/RJJu9Yv6PXNyE8JElI6CR2xo0gkoytFACnhjWdk9iPJWBc2Yg41jGi
ut/Or2x7FNwFff8CsgPXQMpLtbggGqtsdL9+UHgtgy2vMmUxsxOVtN2e33/pcMaQ3zA3U6/U
ATLEF3PFIOs2gBJc+e3scn7gel6HV1QrIVQZSOiJPUd4A1g6oxuC2mF1Ons5gg/Gh8lex1gV
1GXhwVGe2CxDngpO20/cOWXii3+Vic4PBXyLCuyVjk8YIHAvTj1HOGEq/dohRn91r4khrH9a
/PDAI1U2AJLcWQ/ff8+z3i8cjXh5sy7rsYL2sw7jkSXCsTLkmPx75nZs3Dx8pX9/dVOsNnJn
v937GpavQw7n16aymGdH9ZCnd5ef2qK3ON1986/bR75PAllgv4zuWtULeFcDXnRJupTqK9tS
7w1Qa62vMnsY4D+KV2JOe74PWcZ9hEKAn16C63TOkk5m88CpwmzvHE1j4SDvI2z75nYPgosL
h09ruhbfuob+8Sad74O6u35lLt1EA4fLnOufXf9r1qxBVWj9iz4286DrqQCDxCL8/7dgga6y
LqUmdC4FAPXlyoM6eMDn23PZs4/AiR/4PkwWuosCunvVV47Q4genReFm46ZwJ25qvoJorjpc
cSEAx9fWAG0VaT/ZgTdroWGiI3rhIm3USspw5wWnB0CczLAEOeZE2EnekEiyvTi457mo4wBP
LGuna/NWlQOWi7sv8ER0aDZ57bt2ILPTnIAxBGveoaDpbMQYxCNxku1RfWrAkk9Ga6kXbC2O
1Rtt7n0OThfDFwq0viZlXOmEcWD6rhRh7BlrwrAqZELzXKuuLaP9qnpNCSoySOaJjvc0AcCQ
WSIbeHaYp56mo7BVqOyQXgQsozxOs0SxMJQJ4vkjo3uuiV9U1sqr5nHcJ89mWbcByQT7L/d1
9ANn/dpFL0BZM9w3PoNleApIZ7VSgzyGC6veZnlmxJy9kWGoMfUOTxHZcYIFfNIAh1nqteyS
Y9omVTEiMcM/r1Vt0WQgFedmokWKj4vPQLns9vVDbnLoT3NirgP+qjTG4eYOgNBk6xssErWx
cpA233aan3w6dE18TKgfxIIgGXCg8fXKnIrue3HdWCM69YCjCJ+roIVwJKJjdky4DFqMNLjt
Ok7kI5DYT9g82ZHPZB8xCwOUI0bdoF4MysDIFyjCA7qasm7HiTKED0YE4loT7LSsqUKRBO3e
eGqSPlFGB2frPoTw+KlDf+3MjVtwUG3VC2uAygjoDiiUCCR/7PeS1Cz7q4qJNwRlBdMLpk0U
/dAvlWYeiRfghYlSo3mEML1uzNE8HrCIJdESO3YptC9i103Ab/VLOm+EcxiWaWm8auNhklxW
BUWQJEdLcfbOODRZSDSL5D9/TzeMEwefWx9NvUYdz7iRZqOGO1ffJBpMDs7Qs8sztcHuj4+l
UMHEsP3NASsuY+f6Pc86Hid/vNHVZu5EoLX026K60r+hOGUevkyznE2qPZiKI7XNpPn4L45h
qj+WXaK8QK0v8cDEfPBI6W+V6lCfPVWX7HG+0iLKR/c2i3wsR94bv3J+zpHuvClA53DL7RjW
Qx0tr2pr5N3xWqoXoukn3EtFzRyZBwLKpHs8nhmnTWw+objGlRdIuNu4pyb0B7pVOOdtLggz
F1WsJdPuBQ6tFaGNnvvo1RkeHdJga+XjesQSwTAP5F2YPUeKiFW6C2EYaeklcNOrsK+6oPD8
McR7f4DP8OzS5DMngcjYeuNyu1XcyXi3MZDE+anR1PUgse1OQm8Us7JldZIS2TqwXFWZqroU
sS8rmvbdt0UgaM4YjtSfz/wjwIX+NpJEjcParCDcAg3q+nTm/463IEYGs0uJ8gzsn0YFO7id
lhRP1cdXLzes/hp3PqhFZyc+Q0qVn/heJ6ryza4mcz4NJGO8mz7p//BUANgV4QdykQIguHi9
Fexd6IsA2HCN6h4Iisk0NDeSGbh0+5ztoPLtz6Y4UkUQtdsY5n4r2sMpb8fLmGH0N9yCVe8k
KiaoTEHOkAOLoWI1tBnM7FYQO1636vSs57VyM0Zcl3pr73R7RPsnEnBw54yXXWAk9o7oQVIn
+Uw7jrzlnrSTbTky8zn75aAVOIInKGXUGPUad0HxK/CQdmbJcAwpEzqBID/XtXlFrCRtlau1
vr7pnfSQ5aqq1j87qrqMmrEK0KUTPiAnaXNBw51JPe5yXSNEnSCa+FxXrMksxuv68Ekmy0N5
1pjSQ20P/pIDKRe7nyKQ/yT7176QlrvGHo14hxsZBBysh29FTE4OsSooe/A/mmg8en3A15iA
0p4yU4tr+TwOfQDRI9BtUZpNqn0f9dAu9z3ju5KEwHPV5Y/399YmSVDGlc8N7DRPG0noLQ7B
lDh3XLuGlwpWt6prgohZWsEoHpVq7LxRZ1fxKyfN8zFNTerTwv9UKxYhqMr7kzM6VjdWdHrL
MPnAEJmq4sEoAzI0HJo7zxkemCzeBdtaASeClVeEE8uPf8Ls3Zl1cZ560erA1HbdjHnpAsRF
GRMr4eWtpgfNJzbLlqRw3cl4Famcy3x8QktH7gCoqNrmvBL9m1XHwyDvdjTE7o/tWcMyOxHP
gLLX+wEq4r009X1lLyKCdA4Yy1OvSqb9ObCpcVb95/DtQR0M9E1s4ILtPWqBMsKjVSKJIT0v
2PjpKmAjG1I2Vz0Rpe+vGHT1+Q7VtlH+4T6AlbJbVA25src2msIvJyRn5tNRKnPSOMBzN9qE
Ru87udUHeCKcduEsedlAkMAiPsFSZsnBjnZ0MIA20YJJ0YWso5t/9znxSSJPf+sMbePuRPWT
ZRAWJaG7mh0+V64TU9pLxFH+TcsZrdKnvxSVcxpSaBFj0u/qofTXnoIx4I1ZPRq02B12PcKU
GogA0qRZ2UvyVT8g9X+g0BiJN6tcszodJXiwiCsAIM5I565aIsG2vHS97/SUTdRlk3KBAWfb
dSzA413wRmc5pl9E89OkNbhuHVMsT4pWpcjOB9kV/+gM12r/gGZmLPqV0Jnd8fRqUEmK4ZbZ
N8Ah5AIVsr45dtMVsinWsghrQPU3QFY4QH41QMDmdEK580BHTgvnkrdABJe9fJFAusrdUGHm
dENEBFEzHzx/LcqiPFdswOQpxgqBML4575cUyaHUHLFWPbghg8b6iuhabHaJzn/XmEhiQpES
Okczm77NQ5kF2ZxhnFdUpYYI19c2Sv4IIflXoSI7fgvKN1EsSZ03mWsNypOsHggh+0L9N3bv
6BZB8CTcuXwkODuqERKhi3YXCQ+uuTse60vXI2rfHkV8csARFyUHrqGb1avoDf1XDk4LfXlZ
Xfs8JWRT+//B64GRONXcrHgkvJBW6h7OauQ43mJZK4s/5LpZ4N3GbZH0LxkYmBRpTob4W32X
IfSwt5PmCroKAA3toDtH7oIuHMBKA/P+/gsuOEpP7r8N4hbGlWfMVNx1yI3iVsY0j4hYcjws
K9BtAmy36/ry1I1BbCOn0xElL+x0lxgrg102fWsrGQ5kaqgLxxADDAjqkWYz2xCuaP7bEK5o
/tsQ2duQKEIMAX+j8DypWNp0d4VAwkXF1V9IEfZQTwsk5XVxDl6Brp8nL1e1ZOWBZpfi++tS
f5SpVlnzA1IX4K1hbT0OsW6+mW2QGzZ18k+bGnAO1MDUbJNGXrxN02EJbu3sUDdWc8sdE8nu
7kQ/NASNKdJNLV7lApxdYCq1CNB9/CmG/XzPzghSVWQ6vAY4B4uUza9IbOuL1myuJ6KP1hTE
6/ls0uRP3M/twDx2kUaD8tDttkucOe6o9Xsum18ZVrf4OoDn2sIZonLcF6xCOWqmqw3DcnSa
5LZ+u09ctxVH55uopukVt+dmDp7f1mYwdHzMqvSpBxTy1xQiyfDRxOl9xR7f5ylAFK3XWZol
VbjLyR8QbqMB4xLUgI0JAXcbNPevz7DjHV06+NQczw7PlGg3vlDgy/Wv43g57/siV9BgPHn0
/9akIpuETqntkBR25PxrQnbb5Qdb8MFblijQMH/F75iQX6kdtNgT7zGJt+mFRj1RAS5sCMd2
fd9ExZx3Ga9fkFLjaZF9boQuhBfH9ug3gQI/bfZ5R4fdl/YDH3yLUn2nNqjVljasPRWL/5FJ
tGmHNnfa8GmohUGn5Soa21tpDmKJaWXvha0sGuF2nUke78sCw3TAwls4HeijntzDilFkaT12
AuUYI44T0ZUEjtk+m5xN+o6DreWbd2u30UBZ9IPzq6ZClYG9vPFpn99W3oAvaMT/Hx8tNqQ3
oDGHFC5q88RGiVBON1oF7cojnMkc88NU4Djtq5ng1/TrIKZaEsYpsUYpYyDXV/KZZ9Fn9Y2s
ph5xo9B+qdYzE/kWIgxiNGJ9Z/LARMfym8bQJl3eUORDxeOjFOEtafEETvgAJGpx01Bp+hEV
2B513BRi9GLB1SKlLNL3cmLNRGhSrSPvXQCtyJmb/A/2Nc/EpY5uBpnLak3w46ixYZTgSVey
2p/jGspPUQLUKxCSwp+JlJl76t15wAVJuohlmk4FBX7UBcHze/wJbOxjQj6Jnab+qaYbRZ8M
o/2tHln0UBJwhr7F3gPIH0LQlbUvBol8vBG34xJ044QhHJc8eZUxOcQTtixJeWKYft23LgYG
3aJvSvQd8EgEKIBfXqzMApWsr4zkKzdw26aWrYUOUnP8fnJzl6zzrAh6v4ONUzCyXdWc39mA
Sj4wP58d2enLZLwzG4C86q5H896NnxiTQsECkps02RlcjnTjd1/k7i5TDQPUk/4oWzi2Lrqy
pJDONt3V1lXwotqqPQAsoxhD8q0AaVE5IKC/BpC5LK3JGjPQBi42vtpQOEQmMGqmpEaEuOX6
bmdv+iCuQPqeVqXPzEbImaJftnIXR1dJ2Hrg9d2s6GCKcCFjcNfWh7coBUluy88fRa+WFJoJ
g5Q7HWb0OCaitR8+Hdtnd+q8BPBwMYAfc29JVOm6r3jDU6JVhpN8ce52xksMD4gny6zupZ4t
G+zsKdVe1021M0xoqrZg45i9lewV1YQQRjDt7oh+8Z94opicCpadZWemCiwBSr02MAEmAgCu
gQ2l1YaR6Uw3PUNJbbzCXJTAtfRc9LpYvLlcUCnd8zYI7hpFaApul+picsM65WO4Vq2AzmWT
JFYX+rLOQTssKxmB5BuBHLN+o1Mkcei+SPJ/pOMUMe4jtXMDvzBwpbzxil8HTviRc/s0VCJs
AyoGQsGlzJ/U2+RcQ4aRimydO7dDfnqBHKfrJ1X9WbcIxfu37oHOI80QYHex/Zporsm3PSOt
h3KcMpoW3nMZda3jyfkbRgr6fEDrwKYhjSTluP0P9/7v82C/9cCTMCL3ZYwHEkB5cksQskB5
sNijIQQpVA3CP1EU6srpUeVVE3c+cdr5aC96DS5OBGweQxQ6dQkXV78bsRldObC/qUnZNlnP
UE/apQZpY5kpPNzpm2ouTDdtTQtN5huMjFE5FFVnNoH8hNtuSnoOFIxaAf2V83Rq+0FPq8TK
rO0TJmLPA2yy4TwL9sCDG/AmyOt+L0Tv5jUa1IIKdJPQqb07UKTT7cr+tMr8d08raEUMSRpQ
aQ2gftbqJw4ZHLjZSv6rJOyxQf2dsxMXVeLY5Sb4IlMcLrbbTBqzq4sDonCkfTNvE351dkds
iKV//3+fUSghDmJVTq6bdkeoxDj9NLqrgUVQf9835jN/jLpYZ/ucbYEtv0HYKdFAzf2uSDT+
4/pFNcdmSP5+xIS+myfH+Y+PCC0l4jzkSZv0Nc+5R5T5w6AVLG0rzsezniRDkCPT8WAw5gP0
ybyPWP+2+NwP0BdXOUTJqkmCu6HX+F7XEgZzMROW7U8Ev88HBJMVqxcMeDNIG8TE+tN1SFem
fHIAW66dKMdwTSRfnONr3KcKRWQAJ6Tquwy5hbIRWIGJy8v3/aB4ScSluGBfyjhKxaFz4rk7
1HBFNdyQJ0Kiw3eXrD4Helf/4oR4uUmyiKAOfQOsYeH5t6ZUFBtF801wwJJsY471yWRAiLzA
WyIXY0zAk0d+54tl1Ov6VF1/zvuNSFz0V/havQD9PULr0nvGzT1daMFoHSqOxfDoxZHfH6k+
rYlEBeHzdYQ8m1oYv6MhSa1sMBOLbJp8gkI8OvADt8Fgazwwp6HQnpE+nGX8iPGnx9qADsQ8
sjdy8PTcJ69r6jId4d4Z5NuJSBT2tkR6GT8D9YUaMvTn59rJFy7+uF/vDe4J80pTyQKW5MHg
v6SBFbdVNimUF7itNE0Wi3HT9/cj/ls6aLMUUS7rgS37iAdGQvYZ4SkqospnilsGNalCqImH
aJfsd/HxpI4i+EZJqpurwGFZaKDbNx4J4faCUfLfeED1NJfDKQqSf1LVb9HM3rGNVk+S0rAb
cc0AaJ0HbgTEh9rTyI0gC7Z+14LJdZ21Sc6T0MFtvTjri5mPmiv5yfDThswx4lpcHbLgWGXH
PDrsJZuThbp99hjZ2/gXQSP21eOfJBrhEugKqJP0zMwExsF91FarRu575ILBKkYWq4ZDwORC
2Zl1g5ScsHTB2fou0Uy4YNfaNnkK4/Tw8Pm3s8IUGHn2qCHnYZAOtTPVvffjLwArn7cB+7XE
zyRlDC9HpMhEnmY01dPvjCy/1hnadkgNVMtGOmiYLHIiEhX12Bq5BBqrMmTa+SoIKygM6RF/
k0IoA/qdHNNmGKznx+Nqxrn9ygdF73Ekegr9t2y43m7N8TJptlfnPET0GpeA0lm5xcIUPzNB
WTyexsl3LHMbzI/vzvofBQMWEK/StjDdetjTIONsSfWQUEYGZfrwD4d42PypTQIbrm+KCK1E
t9x+r62CDK49FVi+FzeFY5A6z+7XJBsMUbjJFX/Mjcz+ZdyXTV208QRxluf+TRTPCuaPu/IG
mJyIuQFAnYRY7hs3U1O6NBf3FCklCzGRiaOzVNygO028tzC6zEzjU2zPQ+BIY3L0uAK1K0Nn
k2Yg+paVtLrMAEmSp+hnh85izUZDNo/l2kCPJRX5OTVT/P84U3Zg1FFSc1zIME65BCqtzgRt
dAul2YJdltUUUpwjDs4Sd/UZRkiTlNclOiWbOmKhfcTKjJrlibxTbof3dx+JPQyRPcyHILeJ
pwksYzcAocLIAEW7s3MS6b8ZXYU/hlH6CfSvZcZtoU3q7IK1QCPCdioxI3gnZV4KqhBap0+h
w8kBwo157Qoph3m6gEmaWjBy9ZCZ8gqWL/o46eXD4CEZzm/A8Iy6XfXP8E6dejQPO0keBw3g
zlPtLSLC48ZSEQizznNq9TTS/1CNsWRjnBz1O6cgJfGIFVgGM+VtGBRLSmUIS2ChxRxiJqJ3
FBLSFIyFgplKGk92AtHFryB76dYbiKac9AILPQk/Hg7y/QLGLR7aeJ8dfDZHf5ACYPY/ock4
YX3qyxdqg3C7u8P3qWLSqxPiqWgS4nLnAAvF5IyLjxgAZ2NMXPhkk42AFUolKbvsIeKMD1ot
rElmO0Udshgbh8zp/enIhtZdAurZDF3SFwItKwrjW4jpqEFLTVzbV/m0sF8Czf7Yay/rBvLd
P4Qh26A0jiaaLy9/YmICfXhGolkMFy06regz24Ls8QRQWcy2XvXH6VN/s8U1pcy7HFIuJqWY
ELwxYIl7psKnM0Jv5BRgdL9vBqLWrCfdgG0lV7uPIVFPDgGLZEqr9fHWdV0p8FsnRxPPEkA3
qynWBCG4ro3yECpNdJrx6CAQKpd0D9YAPcNd1hiRLvT7gJHYn+mAiFjQAKYe7TWFvqjfuayw
7nE6jx08mxhOuAlItLi8Hrevs9btIV7tHSsVyU4pNEeiJpQed0MTiHR+E41SF5HLczszz5l+
Wb1VR68DQDbv8JuwnSQW5WtR41DkfIfiCEAkM0DPWWiyQsAiyY5Ncq+BC6TZU+gm8l32/MfY
ZxX89FaXjpguvCzrX1RdTCQnjKHLCfMxE5H0yBB6geseY6oATyJoclmbwsA7cUect7WyqwYm
rro3m0QTqco8P4MM5GPKqZUU+kC9D548LJa3fx6m+Qkv3cBHMKXSDLPePzAkLrR2BpY5585I
YjVQjmPlT9hwzQoOsfzVj7EnCza6eRg4CvDMfg2tSjvfgMJc81Zqlwt5svsxS7Oc0SeAuy6w
4bWsxM2osnQG7nJXrEwN1A3qRLhxdnqUqz1quM5iQLQK9DfSw6ZRn6zACMGPukqtXvAYrBbv
fAXFWdVIXHhiKwLWa8+oTLIrFuNxOvZBbLHDsx336qvZIjj2PIWLJu6kae8RcYxTTdo2gfse
Ooyzhwx033JkZBL2Pye5ow6XIb4MyXi8XsHKpKIHiWRCtGnrhy5fHjTwrG5SY6nSRT9+8K6j
3PFiuKEjhq6WqjyIH5fN/Cf7h55zGhuC0LLDKLPESKVh8aRtNZA2IZT+2hvqiV9B8XAP46as
KW21tP1kNMadAOJCMxusI+X/22+CP0Mtu4N7G26DPAC1UpTEtTFlZ091mWOI6SmQJbA+awPU
Q4ebzIr6+wZVYsEomUuLUrs0QvxpwfNaV1q8z7OWHBcAojtfxVWfZGWKC2H7VQIKDTlANq46
So/TO5+OZXNSS0XcuFoa0nyixi7rSQdBu68CtHKSQ9cc6OuNtBZEngN/2DxQS0DvnfxR9D8a
+REKa4ZkPdY9f0HPg7+nhDtCN2pOy+0O6D73ObkAKqQSNe19oW93mU8BNe2P3mDFPgDajRy+
/qWgQZqENU1bXLTvC2xFH87yivejKXr8D8s067/kz26OU6VBXpfwaaKJuZwvioXwq9Ga2uos
iDQuV0DE0GHAGjgF0hh6bfhHwK0PI/76Jyq8hjKKTWo4jjJ4QTWVxoTAJQ4fPm5LWHZUDiEU
xZUHiGY363IOHEmLPDK7z7wz02hDrizxWMTPddclEea14bpExYpR7bHcfmRD3TPn9NE8C8YR
ugJYbmjsdbM+2WCIuIW5AxqAa8B+wyC5LTHV8On8rAExdm6BV3fxN4vD6n6U4/BuK3JeFXi0
sypUeHLcSq97nY+yVawqCJO8vLpLugXDJBoqr5f1gD2yusaDDRFkTPh46+JDJvqlPMM1KZWr
6eeo4k8pz3jte8n0ZwnWoJ9GOx4p6/LL+NfvdVUFsV8RrQTJwCnXJyVkex6UXBB8+k0q7TsI
Ni5YDs9sFWw25julCd9Wwb7K2E0PTq7W4+xhQ5mbXHCpgjbxmNQ1mWPruWN4aM8QqW8VDtem
BNL7lV2G6RdIDZAmunkivwouSSCZ4Q/Rc1p6J9B7OMX8lQamm30FGKoqMTeJxV0civI+nSj7
S5W410wiutx7ulTfusNluvLRHjAoPnFHTGYeZfy3evahgN5Nt1aJFN76Ye+oovEht429/3Kz
++dvfm5o8ZqP2CPiVwmnYMmnZdLICtZ0+/09/TsBTaUJ0+knB4xPQMbxVPMRvBMM9PbDKrHr
ajtctyGEtYYiq6EgdaFcWLTf1GUJwNEhNBORMs0gHdLOEGWBQTA7oqf63y+bfmP0eIYphKzs
aRq8B7r96YNGexhqrIzKZX0VDSNKh5ODpqOaphDUmMZBeWR5SyklpxVBrIxas7ARKhfkf45o
GLwGJAeZgvrL74ohrERABQPX9dOPING8rih51qaaFrzE57ttOo+Ko7i1TPTNMub4eRiKpK2P
gAFGgWC0lXPbaK3pwS51Q4gFr7kFkt+396Cm3JH753+fTWboTL4PAFVr+JQqWdHNAumUSUUd
OQoBhl4fY5Xf2A4yLcnEZr1iYp5VZ28n80B7wwIBcOYI9dsuwnswXNyaKXzABY6GKCO5Or9h
HPxTbQST9MAC9YPrO7eDWA6GTgRoJiyxHOvaNIdgpVrVKoVdwiYQCc9Qj2KJftZJXyr67BFP
FGh0saztIbnQ0E682zszuHdggWXeuWp+TL5Y2Dy3WJX5WTaU+8SeB4Sr8f7CE1i14klOMADQ
vTri2By51UOpBvns3fFIwfvU6ss/qE1wFrBvYdKX/MzHBKNzUj14ZIKF3PW3XoJf0Y3Z6gBa
VX1c5Rks7dSvN0+qHq/TxS84OuYPurDevwiT8TMxV+CE2kDzHLl2tyj+dYqs+gcTOJs4yxss
Pwd1z1NcWT9Fx1k/RcaRH1k/RYgbJNevXbCaqBskVcUbLM12t9AzdYqs+oATOJvMyxssEAd1
z6BcWT9hx1k/YcaRH1k/YYgbJNmvXReaqBskBcUbJJqtGySaC8KZGySadLdPwXCbTrsvt08g
lLcPina3D4p/MUS3D35A+pbAfDqVv+P6lmEY+pa/SvqW/nWKrPqWeGpdnK115Jva212cQ3w6
92s1fuxLLTirx0PV0Sh4il9+rUCRwF6+Juv/jLni29JGMgysiSOG6CB1u9g150gzgyr1M0ta
F/ZF3ByDe0JTjdwiYjyhDdCiNmu7Bus79QgR69Eck0UwoI3RIgWgbXJWTM9hjdEimqBtcmJM
z0h9URmW9Vtgw8GzZ0qNxs9FVfBRGIOilCr0Ub3clKTibZxsLqLHSnmpriS2xMFc8TCx6zoS
jKgHYDg09v1NZMlt7kgYUqBrPtTcYn+OTPiM5DByVsozquuzS1ZWJk8s9XzYzhp1J587xL4W
CMpJOquu4iE/6Hd/rqY1yn4KamCd7SHEpKGup+gDakCSpRE0VFlJIZrdkmoEnW5HUEC6O7gh
/oEwkHftqHMY6DH2xE0qE9OA+W5UhVDPAhnGlCelDyj6nn7Bb38nPm08dZUhmoVtPUYbg4d5
HFnKLluwa+p4+s2R36/rV6pU4vEpxpFEftGrKtdQhQnBPXN5oqS4SWPMp4ncqJAFmbwg7t3E
H/MZUN2MshcRCq9eMoaaMnzwSqgqWN7LuQYFKeS2XYJxr743pSFVT0mrE7CXZkBoa2l2XPne
XIRjA1/jaO91WTNN8rKfvpE21jmcpfskV10JR3kEUzIMi7r9BLh5kRVcR+P2+Iu4D5V+aHXi
Z/9/a4JegqhOdZF5RJcSEphi5AJ8zNwENIgVpwai+XOyjlJI3eE1yCu17NOEI7ufIumJmW4n
nv8QHJ95EngQttbSIHDxSF0wnYC6gReaLTtFSBx4X+ROmiQMa6qJ/fqqnyvvATLpTw6vwGXW
uAZXy8iXKuY8zj1q4SKMmf/Nz/SHaHLz1PsJhEF9XKRcah9ABQcqU2/Xs8Fs12Y2k5qwXrsA
BrziZLdEqVRywTKaPsD3+5bRYFX/T4D6ID570mTm0VK6p/DIbPLm/Qi9NTxJhj0exgqROn+T
1Cw8/uvGJN4DUHWzD/qNVDIeTg5OF3Cdv3fuy/ThYAXbiKMIVXMbvkGsILEhYC+zP+nZgmrT
6LagZr994VYmnl0at65Bdk5cNcgWIg6zG7cx1/RWbOeaQC4hFmRVzUA731eaHiNCrX7+/+35
Q+O8AD6g02mEA6ZruuflMW4Ynid9uwRxVK+oy3r7qfHh6GpfLIfQFyzG/WD3AqLN80+nZRE8
ultbsmYk6be2WzsrddlwDqMucZmx9r9yhgqf9vXuK83ICp/zYXKWYEiBQSUjZUNSChDbDYOy
GW8ppYIm5cewEgZ2MhUZvroTkPk+w2OB3NY4zuTnkIjtzLT9WAoXworJneuo5tKorBfYNRQx
kziXZTAicCeYmV0kEt7rQOCWOEVa5tzcoea0Kf5bRP8whSQK3GfuX+BPG3geKD+edJbPOAQs
8fpVByod5mkOfIn4CCAJIATFp6xsgcWE3FUtObeWeugXTJ/Bs0WIBYba5ReputudX10Q5knO
aLpMlreRYZJ8lvePIK4B/sOfrgHHTdg46ri6cK21oGr4g0Gnu4mnE+oECNt6awWe94YdFku5
Gomad/c6ZlhChumbunqTSf5juoDEq7Nb5G7OqYzezcsyPOcG85UitFVHKCirciiHHMCfdvGE
Qgf2lBp0WXpXosRNGUIQV32ggByFP2BU5eC5x7KA6qSPrXtv0RrxcqAtodjobM2scHCObp8V
GDs1Y6T5aXIir608QMfYzGTZ8LEtAauxrfR9TQSWPGSgCioK8ZNea8XuypXaJpo+umoAZQmd
Kc+NfvtJzaXBu7W9h1UT2+LfonN87W+EB1eBuZ9lYk9RkYy5rzKq9YiBBHuG8akvuObGfdwi
U3eve20VaUL2qKzrBCvK1CnBDxKxf/N07rsIwMxlLSGdhGxCPEOKsTHkXuxRkKCZfhsflRsM
6HWh3gSRzNOBWkHFh6PhcmlttU4kVCGsP+qVI9GNhpov685mOaZfV1PDrd1cerF70DjzHCzW
FcZyvPlzLMCc8zLJvb5bOAOk9WkpGQH+IV9LRqRe2p38c4qkyKN6Qjnk40MV52yPQsUGQPkE
i4MEFL0486fAxjDE27VxzOmdmYMO1myRLax9jmNz3a5rthT4TpOYtstSF1Kcj2xzqhIkNqWM
gFYalNvxzVE64ZmGDoTTGp39FXlDRqrwgiHZli62nxgCEm0p/A/rziN6kKwBMzC8FiIXYWBA
9lrzfJ0C4Rz3IGZ1eePyOuuX/WQtvFKJaJbohjKsLlLKvI3+2x4k2B8o9iBG3xsfCJ4Xk9mC
P0Wi2lVkPI+ujU0+600I9aMnPwqBGgW7AEIHPzRtbWqMhkj4MFfSCqKy0IVatOkTC44l5zTW
sA78FF1WEInagM0ZkyQgI+wRGfPXvtwbLK98WoeZ6dZLj4UaScXzUKKr8rarwWkjLrE1Rk+6
o6kgxQDGHj7+erAhipHY2MBA8JNE2HmXYgC/7K+VwD+QaKnUFWPS+PqKyWNosszerl4wDVri
SYYmo1SZ7Od3NSbTmhS7LLlu6F0jIvh1VrH6ZSwzaiW+SW2h5PabMb4htCUwSmNehjbEJXDJ
QNQwhmFX9dzxiOX70xviIbwa+Crg7qkC3jCcHc0EpZ707Ep6pjKPQWNs0I8+roI5clNJuF+p
2Pv+x6VxxW2t9lZtTbKHpbuSDa8MfgLzgRM4HmXmuw+v/tIEHCGlL6kZojjE0EXW+ssjGY/d
Dpkie1ovOhs7eMvre5zzqd2GNcN7+WzPB7wc92RUhK0ReobwZzmyaE6fZAAVJ17SqbtItIQo
symH4xLW0WP1TvMN3kbgfoWbAGUL0VmR37LmV5CaQjFA4tiPuOWnhmICEbflq9n+og2rJ4hQ
I0C3Jm5dMAc6bgbXK/KmsuU0lg8aJpKblWSGzNR35KDxW+vAFXbHu9hmetm+x1Y02TfgetBK
Y7/iuF23/FRCnB36MBikmbtoDk2wBS2b/+0kBvq/fjDB5yDikxIz0VtACNt6ixlD3XxBjMbS
TNwQhrMjRxlDZ3wcxMb82sShXHIGC4GQhGSgW4F/Epxbr/UwLAO/yxBTnHJx4iil0cS2OUGP
VxCcBwsb3+517dk3pUvyp3/E+DDnikzLdO/4Ukftx4TLjT6tKxm+NaNi6LcNOLsGv61wSMa3
KXZWoTZx73Bdv+IONvHKN8BsvW0BwlrJeNKfKCvIepP3GUOGT57Fap1mDisouzGIZr8MEBez
yjjEg7a7BGKUbkPkMT/xxxEL2atOEuAi67lCdvbVjrh8hTM231O4TDc40brqEQU70cYJH7kD
202ceXgLQ5k8zZxUjF+A0aOxsFsKlgC/9pyHJPI9jbvFbItYVRcYYW252kOSWdGAY8Zt75ac
J+rCHGKs/cKk3jdFygxtvkxpGtGYdqdN1VXv2XdsRbzYVWjs3N1yrJ9bRi1mbz0YPZSfCh45
KFs4ZOljUMouYkZ6J1yxsj9Cl+dSLZ/0MRtZtmhZWNagkf8aXfKPKjnxuejtowAUHOOhNzjT
4sTbWLYPTsaxnQZ+vXfGCUVveJZR8oYOkkNtiQfKXEGZ8lsb44WUAOuAIqHVu1ZPfdd/fXfE
jgVMOLd9HgHhwAg6ViaxDJLy34wv/So4gXgpHLbVDDbpnNTDg/iPS5voXu5BPOQOPXmMqMdc
NgmMgQr7gfsRFT76F3CUr5Ts/U8mpy5Oxq4cu/ceoMNsyVzWpJ9EWv1VOQmBgAOR/2mbJEm/
JVqQV9Z5dXLMd7krV55xOzoOBdrMLsJ4tEoU2r0nKxyRVf1ZtwjFCC8TJL5zXzu1KR4Iijl2
LWTB2Wx9xLEM0m9ZpruzjaaddpoO4fYgz3hBR/yH+KeSq22yqdV/4GSxT/YZrKA2PaXn3v+C
wtkIcGTTu0o+MvOtHYFslr5+d0EcDk/Fuu62wI600vBThEM8t+IRgAGqL04o7Sc5HW4Lm25I
Ng2RXDfWMZ5auvCQW1rN0kJi1RXqIZiV3MYDmAdfRlHMNu1ODNK8NrnsuvddTNh/k1mHNC6i
ZJR8ybNSgD4Yi8wmlrk/B1Lu/cR6FkfxfldmFTxdKAeJhsasT1Moor66A7MWNFoxqCZZ8AFx
Jzh6V0Mt+OdD/ST9Dkd8jaRPFTCTQLCJlYy3T0Uo3Pc1S7M+Vkwx7iY0awHPJzh6Z0MtM24N
LMIg1Ov6ssuazIswY7CjgPFcaSL/HoBBm+XBXOw0Mi/JwicGjAo/0tm4qaP3QWrPba5LZLcp
vtJf9+kIf027iUlnM2OwirxxRJ8jM/Mb/wwt27oLE5kn5BR0k+wmWewa3AKDlMT3WMmoq1/O
/6zToYoWHl/it47xRhORzFyqgvbzU4qhRKtk/cjfeazOrvWor0zvgxRPzdOvIzaK2VhM77vl
xns7nCxS11EzTQJ0POn7ygY8mR9r+mX6m55txvtIh3wuPYi/JxNkxaKA67rTIgjJP3MTD06q
E+KPcuAt1KpISLMgfFJgqrkgUGRDkm9HRzydNxBPqu2S56ppVRIJ/kF37Qewtx6U+ceZUmTs
UsRVYzCz/Hg42QEoGZ9ABtavcBQAEZC9mq9cwzBQslEPo3MKQaV8q/QNYO4F96UOrc9etyM8
jRI8jRIbIhF4Bwb+A+ur9LmIZMa/ETnP9bY2czlHbJ2ki4jRS7KvO56YZ7R1MS6FFxwQ3Dyg
bT++hNTjC57Rw7LPL9VEtJbqZnUukMCNp+erEmXxlEi9xTG6ZtqVty3EuAxpPrBj/TSBV/Xx
7HmQlCANMskgiYoQrhkSAv2s8jOnqTQwRWJMUzugUe0A5hWRm2lTf02RIOMv+vD95qCXGcuo
19Nz1Wh05Qt+iw3GXmFRyCZzOwE2XXb3xCPEdBB9iyUHEo0i9dlQB0jREFPqKYTEdBCF3vRu
xCUxw1Okw0mwiEN6gICHCMn/3OvJ5rqkmpyTBCn189s23WhDhVvPI03e3Z5DC6CAa3qnxjIV
ph5l5HvwlVkaKswwHLyVrJ/gVGTnZ+SdsbUIsJ21czD7a1dKtQjQJPmvrpBIWcG5kyc4jvlh
i9hNjbx5MBa2iB3Y+hZFdE4bLhDnBr6StUFWz/0tj0rF4kRCgaVZhNgfccuCu5u6MnltMo7K
beK9omlakkyzv1tggIYlhWS1Hg3b2L6fmFqwXEFQXEa41BTHI+Q+PpD9VzL5FK7huqcKoK8A
rsn609EVtO9ENKxp+pt6f0704SZI2n2gtW/F/16Ta/nKigjRo8IKQbV/k+Ln0Bnb4Uz19weY
ulwP7Oz17lAMw955FkKu27RuibSmzGU/hDJnUGgt5Ughc+axmn4WuL2VAXSM7sljBq7Bv78v
gUemktCq5O8930HvZW28PkSUJFe2dBvkqb97WuadFtErPgAv41QsWgT0QVXQGaGKSiU0kc4C
saMJAsbMuI1hkUC4gvtzl8+959023dj9XDfAoZDpt/UxkiekkP9k6wrBQl8TOXnNE5+ZcV8Y
8PF33IxCkycPrsEoeH9GbqM7BoHksUYgABHf86FnxwgMtIaLPvVB51Fyw3TugU5qo499LWu9
U4aGEOVouy4qIqijYTQslqpD94+eazI2nP0STKKUG8RPhpUwDZIhDxmlLy/wEU/tbVuvuDA9
0KMpL1nIyuIHb9xGzqgXFj6mfP1xtmQ6zp97vIb7y+J8m18RogcD3LhBW6cxmpuCE6GhO16J
z1nJtH2JZG1KHdMmIhcjt0NM05rQqulX1vsIfEU49csfUA+mDKYOpG8rKgiBf7qnhPhlG1Sf
oSDWLaH9z+S0h8JXh30+BpEtcMBaYwUVp7GgydiFpP3PAO59UMMMHbiWQxjMzrHZuIWtqcVc
ta2qT2B8jif5RJAGWBHDBRuiZ22InGYNmblj9Q3DLxXyoV2vNH7W+biidEwvgSczmExwe23i
BeC8o7ZqaD2XNKmxTvj4CF+KAUwDRMnpTUGClo6FLmUufChlpKorOKAV3OOI99yl4s537M43
R/7qxnTjAekCGrqkNdfBK+nDblj8FnYoOLF81hMeMSCb/B8A0PgdGQi0SNr7n7a3CPXCZq8z
r4+Gq6xOZN1eMGVqUYo65LHS1PsyUObLQDiZeOrz5JD2zyzluUG+3gnLjE4hiNZXXnfeIrwn
0NGlolzC/o9/IHB2LIxSL/5S7i6NDWtP6QV2OXi0D8rrg9f6EEOaEgY2d3LJYhJxADG4FeOL
pb9/k6PTty7s0uKs1abwr+s1zXul7W8KcTX+sQLn2lc51uCuzFUwi95tFOz6u5G99Y4FMkTj
VfTe+5G30NfBT6D+mOw/zSmc152SRVGQ9pWSkU76hwA0qhURTsTswHo2xeeon9/SDBsVLpqj
WZ9XpvkLi5YTo4oAIj+Kbadmbl2zqnFOHAwbP2k1yGDoQyrUXVcfHOH7HELYqHwA3DjrXXqI
WSeX3SfTvxXSAIIw6GTebD8rWpICmnO0RJBEiCAxLnWhgxyGHklzQUnJbBxIL+jGhHj0RLhO
V85J30Q/TzDVhShdMvExVZIdKidahlOg3JiEd0c+SwoUGhSxAycyCiWP2BOSWUQxRom3KLBI
ROBBG3HqaOPA4w5x1s5vM7q5pyF4sRJnbrAJ8y/zxcBZC3YMVkyhJizwcz9zOHTMXbMBIvpW
kT7Sd7SeKxIESuMNkrdPQwnjYAaZmT5clwCsLLdoxcFq7qH8Zj8TUIMVi3yBzB/s2Hqg7C27
XJBAl96WSiCv6ZBWMSfCMticLwpHvQWAANZToTDUSwd0/7Rg3FzYZDWqP60NT2Qh8afAFd8O
YPIXZuNNboR5+WhXV3rlp9puLu/b2pyIwD4YjfGDo5Xrpnnu/+Qjeo1hf0pTZhIZ7Txa4qFT
tDTNN20HGlYkUkmSBt5URVZ6pGoq/P/Maj7HhcSw0hN21f9AihSlMeQ8Hb1dd2qj2JjT3vVa
1XTa44yUuOFzFuMZa0pPUcYqKPj6TWP6YaSBay9PTed5DfOJDuJejvIzPwQqCJNHGQMp+pc2
TOO1+mhkVIx9D3gw2n61YtihsjNy/6kGOKloHSZMoxhl14r76p57/XgH3uZsPMDVepnR2u/k
GNXL0WwUaKUF8zmXJI+XTETMloG120N9HQlmcgDY7+KCU7I3pmW+N6KTrt0xSsntpknvXwfK
90VYhqAbv8e7Mzi9SSvtftLH/ffZzCAFHcHXPmxxrrm3ZP0UZHxMYo7R0G2v5+dsdQIWw3T9
0+3Wzk0ioXuG6gBJYRQuzNYxFJRJL6plmAx83GcEdNvEVou3iFobCIJUH/HHYxoLyQc6ywvH
G5Lpu/6mylKsa3wj60hA4zUa8m3OZnSjOCHYIeUyyY13bnI840I/4a+2c1lGE5mPLlC+FC9T
w02q1NiWzZnBEBFuXDYhLp+ex0RORouufCyhhPCNE98M2AzQ4HS2J04LuTmdRn/10PBziU5G
XOb7fAaeANeXTF9gfI+z6SROIIE1/o/HAtz4O78jcOFj1Pv9GbxqExsnCyhCw6VxI5eUgIKz
/UE1j8MhW4+T8G3Zrr6e6hGWZuF852Af2O/B5F4uMdX/LM5uEqPX8K/yhRHx1K0dm4H5TnuT
Um1kAehw+uUPjVMG3ROO2gcwHwvsqpzYUqcKAcKjRxcKFEPF9pPI3FsZCZaY7lrYAmTbXsys
sFkLH4U3AgGah/oDeE/y0/4Z+JENFbwOfqgmhs8xDB/0LG7h+/Eqavfixrc+7F3++oHO++iq
NKIMBhB176OsI/c5HkFJ1c/fSZ0uK/ZebjguR8EI+D4riXHrPDY2cLmX/oYPtiBEsxip/x1M
dUcE+iD/u/PJyvwYJzhxk6+zN+18/IdOOL2T8Gv/f8Y0jGRFEg/ccNa5BCoTnyDAkDCUWaPu
KruG0QkyV+6WBxRoOUoW9dgw5grzKAmnWDYkj2arwa3EA3PLovNJhT9UQi/SGGq2EkkMeZLD
keAce13nV8hDdRF3c1pTl2bA+8RbSp2FN5k01LOvzNcSn6XDZV6nP4gBqA7BGlkRqx2ZTh99
2kpZv9qhSOTCmOWMORvM8dGlEqLj4N4t+0Pa8gheV1BDKwxJZIWtVXhX7nmwNCUQLfFq9w99
tJZS0px7+W3CpukxqbvwlIUXW3GTrILSOnPOkrGa7yAO8Z4LkUwQq3/v3ta9kSHwlYEFFCD3
ok9oUUF9YMl0z/FPh/Ao1uCXCjMydUmt342NEMoRVpZAAqR8ld0GTr0+QimJ3utZWNuJEOki
x7A06Pu2dkLcYSEP9zrDiFBxVuBVaADvxWNb8cI5kKWuNn9kNy1OvgpVgTBAsaUAFEJCda+R
+/05qOMb9nUVIWfOMM30XsH/q7xgemvbwEE4gByF1qJOId5naQiZTy30cjyRw6WBW65aPQsP
naYmcQf1qfIHcGxH9hvqqJvKEpAuMDpWF3UL/rPlG2cbBhORMu1uVks6S0FHBEsVMndJ7BqR
OciPah+CgUAJGiNmQ7yXaXVsGIakH4GFbovVFWqus3i2NeaFmFxV6gIHYMlbHc58tUaBLbRa
NcGPKvwg/GSaSZuTny/Wsa34009gc9VW45+36ciHHSoa+ygJqpniuxNsLI+5CXukdSi+R08s
OuwOEWA+IrKK5IPvMtA1YeQ45H8AjkvJ5J/CcTvZZfKkUSjmEeF0BqjfdwTIDNNeykOwhBPU
yE79efU7vMT0XJNsmFseebyg+xHCEMuu9PChtx5LTRYfysxDqTNpfPKwLIXel3+idjwXiuBY
a+yM2uK2u07k+yyEdeuP2qYRpvvV7u7X5JLuHP+lgVv101IF/UoWz2vmdcOaCb9OZVS4cTIH
KFyewTUCAo6q0MhgdGXLrifsVluS5DmTr/j6ANfSyomR0PMHGDGfq3LshEDssAhaXEzdgfeA
nYSnXNn3Y1YYqXpXzKStjiWFQMsIWT7PH4jsBO4qzfIjxKq1QgXPa1B21HpDekcYXVhIY6vD
fED8mhnmH1uPersgcAoNCnEh5w2/jfRABYXs0nwvkv8ArXScuECivsGGd7GbHRaW4MVs/zbe
+aXT+KOSvF4QyU2iHmrtGb5mGT7p1f+cC+dugNMAiU3jq+0XlApCr+QAsRH5mHTlR6iVSObF
nC34kijf42lVA4JAg/CKGvMVixxyGJzKeEdl1qSdSWAswIxqEkhJA+xs8DZok+CM84f8XEGj
W81GJNHZpBd3xn7FCwjB/ptW5gNjypQMGMXELS8upeu1v3FGUEJKrSDIm78gDA9l1Y8sHC2E
FYK0HUsNhPBwuW3QH9BArE9jsL8kk9i4fpLYWSSe3QdAGs9nAX3B7LCONwtmYhUsiJEENRLn
W+H1QaJEeWZ7nj7WHVbfrz7ActEStNma/YfSZODitA7H9LRRnr0qtyNEbTGWUIjyJS8L71p+
T1rg9vHyO799ZrNI1Pu972cei8MVVWnC1g7yIKzny7eEKyaI/pJ1VWPZRASBaoxwFjDgTTqh
BMr1PBx2Gkjyks8U5jHFwf4K6Cx/b1yCA6Xp6/GSelaSvPxOwJEBT2NEga3f0meBrSr1AToi
3b1yrumCVXykyeDVc1DTceCLibxz2bWWRo8hHu807MV4j9CGbFcAditB6JBY8fiC/h2as9VH
A8dsaR3dneZXT5VkvzLH6HAM+WC1gDP8xn6do/Eq+dm1+NBo2Sy1r7FlGxfSqo6Hc007FBfg
RuganODH1Edt+dBoCiwqXHchbV4Lp+kMYOlrkIqN4ukqEOArQtHDfIvy0qqRZEae1NvjJAZ4
JMDp8K0vcywp1fvCf+5rtYzk8njJKpio/YISYwqw6AoLgaXVTKQqkxnQJRMwrfnbcgJ/XiyP
pBK9BMH0glEuYVrJNu3TSVCJk/OUSWSJOjzozBRQ7o02GciC891q1fMtWb3T8+D36uZSC9/b
LDH9P3vwreFzLEPq5oLURqlxAAAZ1qk1VVZT6KX8gJ2X3p6qjink0CR6rNkNMMT5liS3u6kV
0RWebTi0Nf4olk3HSELd4TaE0BuF9xk4c4nP9gfm3osT0u/33FGWiUn3nSiSzRnjqqZRDKSP
cCEYg7CcfbgiMDlz4PtQPRXXcAQnkZR1/rem7afvl0bv9eWMEsAgRpQLlLXsJRfm57OtXeqt
eVOmZLO0LozOzozX5fAcuUvMexlkPBaDNYspABF1GmkFESO+VLorMyaDFrwIzrYi5iSy1mQ+
BfZ/bmxBbcBYLrzyBYatIWwUZbRwbXoX91fZ5I/0jtcKfi6UTILnCnXR7BjRlp/rfbA6m7E9
4HQpy7yHjCtFx6UnePCDKf+vSKsuWMMR/gouZJC5NLgb2mOjORn7xLkZwloSVI/wepLvQ6dz
OG2iweePx3+rx0qlnAkIVrtg3JWwceleIb0t8oR9oyRb+aiO6DpMx4/g3xSCuWkMKNtqmXU+
wA1yPiNaztFWhoU+kiECl5nRdF0cjB5ncSHnDLVLo3Leh28IgdWsFwmUGAzCdBSwjHIlSstq
s01V2iwVuYUm1ihlk1bxXsECaQc73NxiX0qsrMaHa1LIy1uRDMCTdotxSsA1wObhz5ZNASAm
XUoubXjIYdqjDRZdzgvbjZ1vkc/AHi/7zJGwXkTErgV7si3eh3f2Pah3A9qpNZDmESdgLuWh
H+dN7yKsJ1z/fa6lmfD8NKhmPWeZ5tSxVPFNMhWwbN0/ip0k7/LjgQF9HJIDZNDm942A1/GW
knzT4GE1JYDOGzBhl6GyoX/5KfSOxnq2LAYGm+u34SbNoJuEdFw/5W9youPgRDNurXYOPcqM
Bv64qND9A1XwLqF0JwbDgcuxIFTulg934qk/tdFi6cDge6ZjwF92DhqJglDDg/eaXBZgTr+n
l7NuKhbjA4qyhmXi1syih5+02HE1zqIhyQfXHzJEZFogii6Flc32Xg46WUGGtPsrNx6sDe12
Xhh3dWYMzPBMsX3q5qb2aLpuYI340TkBqHIBUWwAsCYk+oI99twj/15uJflvowvCkVlRd2NI
NrSFhCGlUGnfA/dbuxtmBCOlxfFWGpmzdxievXcOiWpyh+o8ZQ6S7JECnwRR/Mrax548rmQR
4V+JiJa0KDUNyjNa/5XBOcfRFSmYd0MCS01I1OuYwxvs53zSi1wrsaK/7phnhdK2TVIj/rgm
sMzDEWEnN/qGXB/U3aXcyAkBQN96mLY2NcRr/+Loibt7F6LcZHt0kx5/kEBuoxSdAOVoafHw
XQ1aPXZ1AESoNLbFgjJbymXz1Jh32Y4sTYud5J2GX2woHvqgP5wOQxQtHy0qCxX9yHNq3iUq
o9PXQmnn8UsBMhfjmSGhnOFeG3Hh8HxGBPfhMrCXaF+8tswMf1rCJ1QaMwHKyfIkhT01hONS
cQDBnfEBpossnTw6LX3iOPE7+9+Uzto0QKquQamqmiow+TcH3bB/vXz1grUhE//GeDRkmfDa
0j+ttUZpA4tV/7DrOklXlS3gtm6ZGUmPD7i3m+kKcgqSB4FRP9oQVBBX7k/dfQjWOrB/NSd+
ybX7LUT6wmZGtVgPZLeBtz2rLXT+P82fekxsXPs8URXhyy6hS9zb2VU0nQ+V6zoStFZd3gJU
ZcPwjbq3PeC87GeMxoaBI89z+3Go3DTSuBCyqGmUPQDb5mOKDk8i+IYeB4HNt5wi5BHlw5X3
qlRkH/Vdj+ED8qUerpn1PnUPamZ36z3dLyVSjwl1FrgDXA87f8xgrrMOSQNd29QQ+WqxzqW0
yCsJF57ecIWCGXnUguHErNIQeSEAltm3Z3M8WfJe6csJWvQn61jyG5PlTQOph3cOmzo5e7Mg
DvNzOZJQIOiyczlFab8uEUEcoEecrIOuwfBL79fBeFASPx07wXhQQj8d8MF4UL8/1XnB6rMy
g70MQezr6fqTSui0jRNsXBMqp6546mOTZ2sp2P9WUUd3KXCo7bBgKF3YgfU8Qm+xMD8dEBdS
eRdSTBeILhfiQV4Z9d8AsPIfVuz/K6bPHmlpn/JENKdc88UCG+YQeT1clgKxe5pEPl2Zs1nx
nDrlWUxS7fyO8K+xPT2BCeu/eQO5kut+rbwLpPyH1kWxDrkqTRKy/IfWRbEOuSpNErL8h9ZF
sQ65Kk0SsvydxDkq5YIIxrErGrk9TRIq/J3wq1yM5gHuexF++zA70Mk11ofkZ5sknvrKk3Zf
gsnn0FoOBPnh9aBURaIOPYApmauYrHozIZWlWyJUAm9ZdOpS552qMYi+osJauo7bjCT7EznH
2BD2KL9rCsARRDAR0PVrCpuJ+zYYsXQ5lHkmboUERXuAPOIcUkyU4o7JqXLYpk8xan595XrE
4c9I0JVrCpsVnqVERBb6F3nZcyWepWzZKlU0dkqSTLABQgFEOvJaDzu92FEmd1dLN3524zoT
MY3cNwxhkD+VllvWfOV9mWNT+n+2L/DGOb6oflnX9rJaWZ1WyijNyigqyq3FUaTs7ZxbRYfm
51Ofti2ghBB4QYMSOiGZEcYPkMc8Kb7ZewAXoYXp37KabS7ID7QXjwL7FEw+eZDqn8hkdMop
m/YXzd0iJlt+Cb6YEtGbF9ID651lLvz3onXpJqn7mwz4dDSONcJ2j2H/g7P8jyZ32T/5iyB2
rcpc1vBPnkQhF02D/fjcAbBNQGD92vhHSvtyBDluYRIR9sUk6uogBgPLi/FLHJ4Hn3buJVKw
AHZSUmF8RlGvsFfTa/S1Gq+/LvReEHQm69g2AbBdT3EzGCg1ARjReHHQnPZ55LogfBBncQ2d
1olDz8jGfi+RMrg39SFf9qxh63IqSpNs0PofEGDAp8t36NrA54VtuVYjf+Kd2VODM8pL5Ujy
pCeoVYncggE2KehYJfxjflVHsQy+IeizoVirMiWhkyoJG4X/qz6MIpc2vuMil+XwZSoOsWCt
eGYebsAT9/Xcp0BuZiyY5ey8Nyf6WvReBuEa6H6nW8cZOUVKutlL9nltyDktO/Wbv3ziEn9Y
FGTpaDX2et7Mo5TzJ9k72V2AnF8ChAVVoEreSuIBRX9haOVZ45/3zCVrMhDFLy6evlGzML7P
XBPUAb+z3x7nUmt1inoMbOdqylhvheAFHl0ZnAPl/HSNiq8862wITuEkgPojraEiFd363tAy
6ZGKDobXxZ5eS+5gXPFkExUJ62gAtDQs0v8/MXGhWEZbdLN9gYgPWbPC+k7XD1m403ahGO+i
pniE1MRO5ktS8GZQhkxhZ/A1kDhtvmh+yIyvFlvAG/mxmfFQYYFXsmfJqM5aE6jIkTPgEcP+
2e6oAzma5x/pPm9cMfpOqA8QPXqXZcpC8WuAy2mBwmThzXGBjA9A1qlU7btFf7K82irvC+3t
lIYZwCcMVQvLOxCNpzAMtUxkiUAjik2IV/ffSJc3z+eYnXy9N24+8lkIZSEUDP87RopkhXiY
NzUNN7fKS+oqhCrp35xc72QhlIFmI3HMMAEKxaDVKyphCpzgmfoc0jv8bJfP6aelR4PFSe6n
uteHk2fSPUSXwsNNPdKscHFiC7A9JyPMlvq24WQhXNIJfnECvCXDJfYSk+KfN6oh//Qae6IN
obnekwNNDSOC1o0U6+TDt7p1LRsMXvon30PqUo5xiIuEPXIDOqkFnOjxK1uuxcw3qbxsXICX
oxUfEkxeHT4yWzuNE3cmVZsyxy7wtPKmGioNaa/PYouUJP9p3rk+lBqHeNDBDL7KuieZ+MzY
eQXQI+3a4mS0oDEh82JmrjEZlNcwLs1HszpjccwBxRhyujqoVCI9qC1xN1ZFHS+k2CvGhyQN
YguMaBQ34vbHcIBseHVs3VZrBfeC/sk5EuiKC0dw0I7ATLYDGvWfHW8jd3tkbtj1zkhUnQSy
/BeQ2e4C0nR+n32M+Vxn32zcL/LCZwV+M3zGbMR/UJPNDdyYhHevXrS5ESr/gB+U7CnyWriR
4V2Rr7BWMLxETwljxXLblREhDoL7PBFqw6AQKlfQuhDSFBE9unMKHM/dacUJOZaT1ef6uaVM
KKQ1wc2HEdyuYAgWSP57TW5G0eZSz5YCbiVtE7qdi6pUmq6zT/j90vZzBatzvIcQ0gq5iOxs
bk4bAymRp4mU6x7Irm0/0efjgBaPVdR1nG1Skc5JOoWL6j33dS+FpAJ9YY/txVJmfK9Mp5Fs
EsAwuLhQ3b8OPWrgfw/itxN3l/6fQdEa/lLxz+VCTjHSA3gRkD00bczEXk5g+iAe7LF2vAjU
ETqYhkNkcEH88Jz0xqk9Mhtu3FvWPk5+zNcStIwi0zS+Z5AbWQFinmCOJdm2r9uJzw5g6Kwm
fb0DVj2rjWBN4e4qxcK/LSeWxbxkWCEjWJXepxvXcDDlKtqNaAfeH17465/JqvJ13/XXiBVc
9TBCg+lW34I6V6x3cJHL6eNg2X89q/px98THLYngM8rB2yZCfTmHS9wDicKTtjHF5Rvpp8Jc
3+dU+wqhbXkpfhu+/f1d8gN2HX9XfjnteK9pFedhj8UMIL+lsekmkvRDLAe1KiTSXE5lq+Bg
nhAOVY74WkvsOYPh2rCP5DTTd1iKiMxq7A+B3fykzehOTaqtTdLvIb4ZKdrQ1eqV89WjfdPT
axKoMWtXnzWr29WZBLO5a+aN2ES1mSePwR3T0eF5Gwh5jOjVtRrMbGHSilKr6WbVsKi2Adpr
1XNJfeHegp5bcxGOW5CffMNqeE1zWsE2YlrOny/rizSe0KFcIU6qtQ8NquS9s5/1GzjTh5Q5
Te/WMJe6nDcbpFkDmh41jBFVGMTZiDVcAHeydCKybk87+4nuA0xE1k1IzWT2w6oYRQTgHHaD
YhG69IGP9a9yzRb0FPuyGh+1sURIkkTdbazHfjpA9FvJ6hIRcSAVU/T/BcmptE0rLzfx4yJI
T04PzniMj9LYLDK+ScpUbFdx2L9+VY3Onugs4fnzmdQtpHcxngaKdnmfGCG+Fk57unl6CrzB
4fEEIgvdiaJL77hafYAS9b1Ow+kHxpZrwbUhQZZBVrfa2zokiGSHJGAfykv0qQw9hk/P/sx9
afbQepocQktvi78C2pUIyYRfMajiiucMwOjf61ueismXKZ5WG+HrZdRMMr2fRIHMk9/0O3C3
kxrv9kRDF1YdOJlYXCDrVHZYkACSnSTnEsmLdupXmYDXmf0dmoTEluuUNoTdwLduK9u8UI1e
gxfV8oNdbQjwpXJOLvFRr+PImesqGIQqMf2PlvvFUF+D1swAETdP1N6OortQEC5F4DfnbJMA
qsJU/7tJCho/KGa3z9xbYuDa5lQF0Bl/V4rR58LoMC8CF83EymZzwfxySMqaRvPKjrEqp7kA
ZPylnDPKy5pKFRxAqeVlkxxkUJZ7gmdwKGTGA9CGPWEX1PjL6GDIYWu1takv8UL4Ntaf7b1U
/QLt9/4DdrgDoUbXW3K4yEMk59ORMm2E26x+BqHD+wAz/Oomrhp1aSg7jr1f/gO62quvBixQ
wXqCWQo/mXmbhlnx0U0t46jFSZAmx3M44CJN8KM71rLnXTW2Xa2Bj5avuqAxszTEcoPDzZCD
IwlZ4eFWlLdwFrPs7XfD0FDKcmmSWMPsCUm20tReazQCg/zFLFKN9Akk64stKQGbFNxTl9vq
w7zsoS7H2wowJWEWcWLKoyrO0gyAIrnKlIoNzUFzBTIemuKutUp2ksQe151M6vnNkgggsfSd
X1udMaqdX068MTKdX5q8bbG8beXK6rS5j2ogb3d4bvU5vhxzi+UH3LJdkv66oH/c8o1xILV5
TVx+vLVh/wCWS7StN6Z+XA9X14kAxak7i9VJzjMv+2E+Irij4zQw+2G8JswdVgHNrx1+XA97
LsPyGVR8YhcG7kYtrThEYeK9d7oXg3t9onvA4cu0RYsaSgGzWzAsEOoz42RFVbRED0kUN6jj
RF5KItf1jCNq69gR1o1+/BNDmBm1bMMdqLjXHMDyMetwBCIkCQ6bhkfy29svOZx9TJ+uobiK
1vWwMjV7d4q/Z2iNnsRGfy+GpophGx8zlA0QQeYxP1gAehF6JDBCMNvRZCaZqLGidqL3GvQc
ld4M0mah8BeKDTB/aK3ssA5equtGwAcVMnetyWDlVdy1ct/BledHXiMUdP11JZ2VBqqlsLmB
E3Ov2jTADmIuIKCwnBek2IGkAsGR7UrLh/O8iZlkqYvTD3Lja7b7VpOzUZX4MdovSJvIZOWy
zSwwgUUHb1Esoco0JAPRpfS+RIYmTeprklQJJkBw+X8eOk9LZd9EZtvOLgud3ooYzvSXfeN8
nOrzeyDj+8PknKije8MHgiLmavKxY/KWJ8NHd6iVCEE4/USdhsl3kXLS3q2TSVLCcf+cf7SF
1Cw8bQsg85pJCpQzZwFBA9iHPvi+4M1esCviMpIawwUb2sxmOogJNct7/4Oqmb04qP2EPjnx
MVOqkh+i79yOrSyO3fZUCK8TgfsjuYY3OlxE02JaF4i68LOTf6cCyqcbKaQN71pVHymROFgs
knI1SFs1q8XQnXDvXvyjX/bHrkHxSQ3GXJrzDg8qy8nfD65IJn8Uq+1d21Y9r2bNfhmqaUsi
lCvuJcrlwmIGk45AMdriNaR/ahsI2KjiqksmMto8Rb4teqcFBTHMR81IST7V31YussmZPUdK
K6RrGRw4rZWvuIUzObdeYZhtE1o/hgA0I1M5hs+cTIokCMczZA3nDMhEXhQFwArX3Lm2i/NH
LxVUdmjIa3Mk+QjQMD+pKaJPED3AVVNOoHUtr4uCr+sCMAFEIYRNzDT/2n6mQHhu5LtGVOv2
eeUD17zWx9y058Zemwgje6rQB1Ce9GhB/C5Gf5zjaWv0r5G777TfIL9qb+8m1FSr3Dz5RYgz
8Zrit0R2ZRnPc6iT4mHbzDBCaKv1fd8ctcfk/c4FI671Tvz0R/sqBxdWjIuFyqvjIP0sSCx1
zZqCfAUipgXEnt0r3xQZPOEDQw1h0P9h0P9h0P9h0P8zmOP/YdDZYdDZYZNxYZBEAQVSomGQ
AgsFzFZhkDbgA0WOnZJ49Jdh1sh+D5YcBbHn1DM9Zi0QY3x+D5Y5BbHjXzMNUWR5bNLs8HAh
y26GSwEHQkiJlIqCTdSTJvr3ZeWVZmRNo/iGsexnzKKq0S6sC1UWU/GAeV90Nl0yRskYf56T
aMQGGiXoba6+LH8Xr7onFMmL9d2Y+hNowytcdl6sA+0XTDzEVOK1RM0d9aP59RrbDZjcdzMR
cX3a9+Xs+Np0WzC0KhjEYAzhN5wUsjURAsy4GB0jdaOPpoK6v8yuiQISMfFbGJeFTjlzWD6A
7YgCZ+GS86P32Ye2IhcgLUKdEWassAn2AGYCZQhlsuHeHYUuLJi/55/FKtAZYlRSlw7VpZGE
QDkEZRFL+IoOzCAzlvO542B0Jg3wP64Oo42fi4zx0VrlOt1cXAqeOG5UFvAOUVynxhavJmOQ
JsA++c5GQuXXRq80W7JgLHMb1eyqCH4/plhX6PLEW7JkhOEeGv1MeQ1d7R/vU8l0/BqXVJ5I
SVUvX3WeaxoTxRzX+jWLnDVMI0C7QBHVZqD11lDDqH242Ag0JU1vqUJ94U7pf3WujQRG4ffV
OYqFY9aWba/Pi+FOXPt1ADJS0lTNtOnDAgcW1gpBMNCg2pL3WgdGLPkG4AWKW9jbxO9kB2OF
Hu5BNOFCAGi3sUzxsWqkyLFqefGxaqTIsWqkyLFqAEJzYF2B3j6bkvWuhzc0IlW3sUzxsbDa
ymSuxKGHT7mpNCJV+0IQRUlkmuM0HI1mZIASm55dgRGuh7+hh9CfZ4fQYaGH0J9nh9CfZ4fQ
M12B/fexF2OFHgMAQkSbkn6uh7+hh0/NqTQiBRtCEGEdm5J+W12BMUE0P++bkjSOQhC8SWRn
h0+7+h7R+h5OpMixwQUUZHK/Z4dPu6k0Ipq3sSCihw+JZmSWM12UhR5tAEJVbEIQLR2bkuAT
XYGVy4UebaTIsR8Sm5LwhR7ZCV2BQ0E04UIQvklkmBRklr9nhw9ItzS8aPtCEL4dm5LAroed
80IQXBg0vIO36spkZDNdMpxdgT3LhR4KefGx6trKZGSfZ4cPzfoexKhk8NZlXQ1SS0lk4zTf
yzNdMrBIRFuYpdVXtOULr6/RepnLn+6juEuwLZrj1KfAVSeKTMR88FWYSM2n1Lnbv/aY/7ra
CBmD9Pg8GaoeurO0Cfm68O21b+gtErU7VSW0TFe4KmH8rz20ApnqCx8icfDttrHEUS1jblOr
EknRWQv+3HGYYy2YpQYnfj3wCi2ZJOLU0Xa+qxKu4iDpCwxCwCozQXF11LkAvp8MC7/ulz20
5ZbqCx//cfBMMMcqM7lxmhjUp8DBJ4pVvnzwVZjHzafUuRVPCi1cB+LU0XpFq5i4KSeKEEVh
DAsTc0icAQZRrjrbBxNs0r2oAEqwG2bkRfQS7Nk2rLzfwevewPCCvQLAgxzxYN+Zl1+E7be1
ITd88JEyepAjbSn8D+vOqxBfscd9Nw8ihqjXvZlbBCdlBKD9ZMpgEJA2eEg5pN3F55a6s/O8
N6izrWBVVqcKY+XxUN8K8oeIxR5eSIaXFQo0/Ob44DL2+JJZ6wSm/peHk/LC2ercD0PE/2wO
p7pyh0OpKQptxoeI5fzHloblkwk5EFwQo5HmzY+Na+wiEyHiYA+IxcUt9wMY8ofhHnotdix0
4f8k/XiWB4w/nK77UehEJoM1DDEyOmzKOgDYDWOOR8/N0o37qSLrVziqJeqDTvbIi/lQO4Ds
b9tLHBRs8GFm1ysLh4XiaLHY6W5C1HcUqycM1sAziQRTpyCjRftLB57DHw6g6PObbDbOi+sg
2oRA7GBLwINvSPmJX9GtL0bNluaFBfm4ZiZ3HWovhzVA5sB7SIVmkUmBLcDAHCD0OLiL/Rpf
lmYLZ0GlijVvfyJ4yt9EfY5v2hPfNrq9ApBVMBXEze4RVFbkDVMb04ortL14KDtiQ9fJva0a
UJJkAJ09SmlzP9L/wUVskSjqcqadeP4KGaq1bmBQ/s7DipEYQx12CeI1URRuRQjJwl9JAwW+
qlHD3R5bArGdOxBSfD4wP6bmbyg/DtSpkhStPDPCuQSCKFJe7/7aAfRwbsjUZaRNn4N3B8gk
RUE9trdJETiRQnCRub017HLxREWrVkhIc+wPByRcEtysj7Qehom6GSP/6GULBxhya4QMqXjA
ujHKnsTOasslWVNszXYbA/0hIBn4Q+TrxZOSui7QExs9r3hvd+dohNkNUDiTRvs8qNd6be7T
IneornzRkLdJzvUePqwTyzunrlluQw+PeIIveFohOfrtz0wrIWo71iTAUCtZvz3B6eabRjVv
9iBY5B44wllI5OXFcshN6PD4f/VrxbYxiUeLiwW6hqAUJ0Xt8fqhVjDSfFgZMK8PrMQc3AAA
YNoRQdPKWko0VS7bUoQalBArKdO9Y62Ol9mRu889LljUVo0A5RgrLLxq6lJVCisEkwkS3+Yi
LSGcwRtsy25dRzii+XSQKrz4fHy2aeLG3EemkfwZYD8Xpy39q4yKxbhYpTdu2eHW4hdypFB/
OyGHEn2OPgeBlTa/UcjcjrOvjk+VS2I3tWvCe84k+DruzJ/QazoLWvyk5lhL21lFElFOK6fa
KB7PhyafHkkbV/HRrN5Mp6JieRFUF0O4AWSUQUSckPfBWztImMFecBUQXOvzcXBUsJWiWnVG
tnw+VZXIVhAGsBU5KHkO69yXk2YwIKxNQvOiBzEWqSy17sx8FCbjwnbAKXPmdVkzq3gwZj03
h7r8GnMaPezBeXoKVKMqz3jY/mSskhMbESFT0yCs/2zRUWKoR0XZie9FajwYFVN978I3zksP
0oTJZAO8H1kUjUFtpPEqYhhTuUoG9eldGmknkz8RweOjRKR7iAfmGUkhIFRY7NNF/y8IWIyl
ekahCwmlaDjj0x4bMc/wnPB+VIkzuHV1GyMG/k0U7+aiZnMr2YcDMttkKXi5AH6v0pKXeXE+
t2/m8S9IoByErej6iqifbmp30jqTd7vl9v8UqOPS411qEtcjciFydYwMWw7o0JF2H826L5EW
bDKuQuK7HOGvwz4a0DUAnROgjIhhHulvcQdtyntilhX6yFd4IKseb0/FzbTBPc1oZR43/dPo
Ug6U40sLovg3jsUNWqk4xTk2McCG2t87zK1Hf8twegK2PFrXIRHfALJLiXM/2wjjjjGlysXw
xZXDrMnOqEJR6XzmePMrskbwL3RHVNTiVk3VaXzNzh5+L8/zUl2OvTEwtO0HVvur2qO+r87R
CLksK+MQOnmsP67JGZKEBvAfbSldI3SjNZ2XIPpxONEQRtGaMc1ML9i+XD/NpE3epSUDGFo6
sz5vMxkwrEpkvzHpxy9EVahwkjfdTQbBbqBKpInsCSBnF2rys2plamoDl4+BcilmEDqspbXZ
H986pXOhhs5+49THN9/ODiRTdvWSIHfZUQLLBMsY1hdb2MLUw0Z+XHrE52kS0tEi0JKczuOm
5Q56jhpOF82HDA9/hoeliUtkXDKiFNfer4a7j5OGW5zMLUDVz0lULCW3e9oxlvuDFg2NBNIH
749qBcrdjcva/ZiaDCJCCpEN5hM3l5ho875xSr9KZh5WInDJvToGSu8SCO4WdnyXl4InnjEM
v0XdIRPLKs0sZiRJkulU4T8GA2PpDA44ACfP++IdU8MzAKqzUV1Px6JHvLlFCAe3JgvOJ/g9
RYGEYW6bkGMGnQxnCaKVBlyNGcCyyJe+A0oBOrg3teVOSLlyE72DmHhTXk8bcNnE8t20lfiM
v5humhJU5uMPxnerF0MQkshWt6C1CF059wZPK1TdlaQYijrPQrdW7f5PXvZBMAA1TzyGEn6a
wI8atV1bmi9XOqRZ1M2R30HTa5B877HrOhJ8XZeLQ+yIOWO38QD0LQTSDcH42H+a/gwzH9nW
9KLYywl/LxnvXW4kVusBpRt457e8z1JPl3p9Y6UOaSgvGfjf0oUj537XledSvwX9IVub+Igm
ZxwDCoEoq8xxZK71xhfjXHkIIfpGBc09/PuoFnWgLsm/QVqRxIyWsOSCKqiJunZyVIxN10Wx
pLUYi9L7LooXVOvpX01bR82RAmGzwPSnkZIxumLxHvrNFL6ok7E4rCFlrVnUWM65isIHjdnK
zG8YUvH/ZgZiZhrg4XQcrOv86z/Z7e7aYvSktSUg/vXmxi5G9Q2yXad7+5qnXUrpQ0bmtVV7
lsc3pMymHhsQQ+lUjnIu5Czmc+lH85lGUKx7fr8JS3Ahnuwfeynq4uTZFvvZC38t9RQ9nfNq
4SVN3GFnYx1Vj3npcSblFPfTIP5Uo91S1CaiDKbMTmYh930/mdS1XCjYpzTyJCdrJLC7NHjN
pZ4WG8ruS5OBZrnLjb3vZSHnL71CHbF6oqXC8SYR3LSHVHavLm0W74QaBg2xUJoUdd03E8J0
9Ozj4P+LcGCpVAr4CJKSHRuMRvIZ/5zTmT6W8Mp1kYVW1wObcXgfKacvlbdhrXDXE44Wqx0i
J8VXaURLfgplBUeK36KNqFwA1CNl/8CVNpeEqG2u9NcvsC5GhgRppPkWIaMOwXoqIOkwlgXD
WhMv4EHneQ7EJvLGaEgWjg2ODEkV9zS0u207Q881VG2oMS8/+gwOwGKAY/MPR6iKfVEARuzx
+7BASzMVxIx1kwIVTeeS6B7UjfFHed4+DMRAdmqzSFx0dSBESZ5ngwDbxNLsa9TE22ZMPmns
tuJLJeTJCWHnPUcV2vty3PlPtSznq29r

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
