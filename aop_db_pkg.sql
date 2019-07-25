set define off verify off feedback off

create or replace package aop_api19_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2019 - APEX RnD
*/

-- CONSTANTS
 
/* AOP Version */
c_aop_version               constant varchar2(6)  := '19.2';                               -- The version of APEX Office Print (AOP)
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
c_source_type_xml           constant varchar2(3)  := 'XML';       -- Data Type
c_source_type_json          constant varchar2(4)  := 'JSON';      -- Data Type
c_source_type_json_files    constant varchar2(10) := 'JSON_FILES';-- Data Type
c_source_type_refcursor     constant varchar2(9)  := 'REFCURSOR'; -- Data Type
c_source_type_filename      constant varchar2(8)  := 'FILENAME';      -- Template Type
c_source_type_db_directory  constant varchar2(12) := 'DB_DIRECTORY';  -- Template Type
c_source_type_aop_report    constant varchar2(10) := 'AOP_REPORT';    -- Template Type
c_source_type_layouts       constant varchar2(14) := 'REPORT_LAYOUTS';-- Template Type
c_source_type_aop_template  constant varchar2(1)  := null;            -- Template Type
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
c_output_db_directory       constant varchar2(12) := 'DB_DIRECTORY';
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
/* Internal Use for conditional compilation - see api.sql */
c_apex_050                  constant pls_integer  := 20130101;
c_apex_051                  constant pls_integer  := 20160824;
c_apex_181                  constant pls_integer  := 20180404;
c_apex_191                  constant pls_integer  := 20190331;
c_apex_192                  constant pls_integer  := 20190930;


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
g_aop_url                   varchar2(200) := null;  -- AOP Server url
g_api_key                   varchar2(50)  := null;  -- AOP API Key; only needed when AOP Cloud is used (http(s)://www.apexofficeprint.com/api)
g_aop_mode                  varchar2(15)  := null;  -- AOP Mode can be development or production; when running in development no cloud credits are used but a watermark is printed                                                    
g_failover_aop_url          varchar2(200) := null;  -- AOP Server url in case of failure of AOP url
g_failover_procedure        varchar2(200) := null;  -- When the failover url is used, the procedure specified in this variable will be called
g_output_converter          varchar2(50)  := null;  -- Set the converter to go to PDF (or other format different from template) e.g. officetopdf or libreoffice
g_output_correct_page_nr    boolean       := false; -- boolean to check for AOPMergePage text to replace it with the page number.
g_output_lock_form          boolean       := false; -- boolean that determines if the pdf forms should be locked/flattened.
g_proxy_override            varchar2(300) := null;  -- null=proxy defined in the application attributes
g_transfer_timeout          number(6)     := 1800;  -- default of APEX is 180
g_wallet_path               varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_wallet_pwd                varchar2(300) := null;  -- null=defined in Manage Instance > Instance Settings
g_output_filename           varchar2(300) := null;  -- output
g_cloud_provider            varchar2(30)  := null;  -- dropbox, gdrive, onedrive, aws_s3, (s)ftp
g_cloud_location            varchar2(300) := null;  -- directory in dropbox, gdrive, onedrive, aws_s3 (with bucket), (s)ftp
g_cloud_access_token        varchar2(500) := null;  -- access token or credentials for dropbox, gdrive, onedrive, aws_s3, (s)ftp (needs json)
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
g_start_date                date          := null;  -- start date of calendar
g_end_date                  date          := null;  -- end date of calendar
g_weekdays                  varchar2(300) := null;  -- translation for weekdays e.g. Monday:Tuesday:Wednesday etc.
g_months                    varchar2(300) := null;  -- translation for months   e.g. January:February etc.  
g_color_days_sql            varchar2(4000):= null;  -- color the background of certain days. 
                                                    --   e.g. select 1 as "id", sysdate as "date", 'FF8800' as "color" from dual
g_separate_pages            varchar2(5)   := 'false'; -- start calendar on new page (true) or start calendar on same page
g_alignment                 varchar2(5)   := 'right'; -- align text on calender: left center or right
g_title_alignment           varchar2(5)   := 'right'; -- align title of the calendar: left right or center
g_day_alignment             varchar2(5)   := 'right'; -- align days of the calendar: left right or center
g_start_of_week             varchar2(3)   := 'Mon';   -- start of the week day: Monday (Mon) or Sunday (Sun)
-- HTML template to Word/PDF
g_orientation               varchar2(50)  := '';    -- empty is portrait, other option is 'landscape'
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
g_url_https_host            varchar2(300) := null;  -- parameter for apex_web_service, not used, please apply APEX patch if issues
-- Web Source Module (APEX >= 18.1)
g_web_source_first_row      pls_integer   := null;  -- parameter for apex_exec.open_web_source_query
g_web_source_max_rows       pls_integer   := null;  -- parameter for apex_exec.open_web_source_query
g_web_source_total_row_cnt  boolean       := false; -- parameter for apex_exec.open_web_source_query
-- REST Enabled SQL (APEX >= 18.1)
g_rest_sql_auto_bind_items  boolean       := true;  -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_first_row        pls_integer   := null;  -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_max_rows         pls_integer   := null;  -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_total_row_cnt    boolean       := false; -- parameter for apex_exec.open_remote_sql_query
g_rest_sql_total_row_limit  pls_integer   := null;  -- parameter for apex_exec.open_remote_sql_query
-- IP Printer support
g_ip_printer_location       varchar2(300) := null;
g_ip_printer_version        varchar2(300) := '1';
g_ip_printer_requester      varchar2(300) := nvl(apex_application.g_user, USER);
g_ip_printer_job_name       varchar2(300) := 'AOP';
g_ip_printer_return_output  varchar2(5)   := null;  -- null or 'Yes' or 'true'
-- Post Processing
g_post_process_command       varchar2(100) := null; -- The command to execute. This command should be present on aop_config.json file. 
g_post_process_return_output boolean       := true; -- Either to return the output or not. Note this output is AOP's output and not the post process command output. 
g_post_process_delete_delay  number(9)     := 1500; -- AOP deletes the file provided to the command directly after executing it. This can be delayed with this option. Integer in milliseconds. 
-- AOP Config
g_aop_config                varchar2(32767) := null;-- AOP config file; anything here will overwrite or extend other attributes in the JSON. Make sure this is valid JSON.
-- Convert characterset
g_convert                   varchar2(1)   := c_n;   -- set to Y (c_y) if you want to convert the JSON that is send over; necessary for Arabic support
g_convert_source_charset    varchar2(20)  := null;  -- default of database 
g_convert_target_charset    varchar2(20)  := 'AL32UTF8';  
-- Output
g_output_directory          varchar2(200) := '.';   -- set output directory on AOP Server
                                                    -- if . is specified the files are saved in the default directory: outputfiles
g_output_db_directory       varchar2(200) := null;  -- set output directory on Database Server
g_output_split              varchar2(5)   := null;  -- split file: one file per page: true/false
g_output_icon_font          varchar2(20)  := null;  -- the icon font to use for the output, Font-APEX or Font Awesome 5 (default)
g_output_even_page          varchar2(5)   := null;  -- PDF option to always print even pages (necessary for two-sided pages): true/false
g_output_merge_making_even  varchar2(5)   := null;  -- PDF option to merge making all documents even paged (necessary for two-sided pages): true/false

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
g_output_watermark          varchar2(4000) := null; -- Watermark in PDF
g_output_copies             number         := null; -- Requires output pdf, repeats the output pdf for the given number of times.

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

-- convert a blob to a file in the database directory
procedure blob2file(p_blob      in blob,
                    p_directory in varchar2,
                    p_filename  in varchar2);

-- convert a file to a blob
function file2blob(p_directory in varchar2,
                   p_filename  in varchar2)
  return blob;

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
/* -- Example of call:
declare
  l_binds           wwv_flow_plugin_util.t_bind_list;
  l_return          blob;
  l_output_filename varchar2(100) := 'output';
begin
  -- set the output to JSON, so we see what is being sent to the AOP Server (uncomment next line)
  -- aop_api_pkg.g_debug := 'Local';
  -- set output to own custom debug table (uncomment next line)
  -- aop_api_pkg.g_debug_procedure := 'aop_sample_pkg.custom_debug';
  --
  -- most minimalistic example 
  l_return := aop_api_pkg.plsql_call_to_aop (
                p_data_type       => aop_api_pkg.c_source_type_json,
                p_data_source     => '{"filename":"aop_template.docx","data":[{"hello":"world"}]}',
                p_template_type   => aop_api_pkg.c_source_type_aop_template,
                p_output_type     => 'docx',
                p_output_filename => l_output_filename,
                p_aop_url         => 'http://localhost:8010'); 
  --
  --
  l_return := aop_api_pkg.plsql_call_to_aop (
                p_data_type       => aop_api_pkg.c_source_type_rpt,
                p_data_source     => 'report1',
                p_template_type   => null,
                p_template_source => '',
                p_output_type     => 'docx',
                p_output_filename => l_output_filename,
                p_binds           => l_binds,
                p_aop_url         => 'http://api.apexofficeprint.com',
                p_api_key         => '<your API key>', -- change the API key if you use the AOP Cloud
                p_app_id          => 498,              -- change to APEX app id
                p_page_id         => 100);             -- change to APEX page id
  
  -- write output to table (uncomment next line)
  -- insert into aop_output (output_blob,filename) values (l_return, l_output_filename);              
end;
*/
function plsql_call_to_aop(
  p_data_type                 in varchar2 default c_source_type_sql,
  p_data_source               in clob,
  p_template_type             in varchar2 default c_source_type_apex,
  p_template_source           in clob     default null,
  p_output_type               in varchar2 default c_pdf_pdf,
  p_output_filename           in out nocopy varchar2,
  p_output_type_item_name     in varchar2 default null,
  p_output_to                 in varchar2 default null,
  p_procedure                 in varchar2 default null,
  p_binds                     in wwv_flow_plugin_util.t_bind_list default c_binds,
  p_special                   in varchar2 default null,
  p_aop_remote_debug          in varchar2 default c_no,
  p_output_converter          in varchar2 default null,
  p_aop_url                   in varchar2 default null,
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
  p_sub_templates_sql         in clob     default null,
  p_ref_cursor                in sys_refcursor default null,
  p_ig_selected_pks           in varchar2 default null)
  return blob;

-- retrieve underlaying PL/SQL code of APEX Plug-in call
function show_plsql_call_plugin(
  p_process_id            in number   default null,
  p_dynamic_action_id     in number   default null,
  p_show_api_key          in varchar2 default c_no)
  return clob;

-- check to see if the AOP Server is running (function returning boolean)
function is_aop_accessible(
  p_url             in varchar2,
  p_proxy_override  in varchar2 default null,
  p_wallet_path     in varchar2 default null,
  p_wallet_pwd      in varchar2 default null)
  return boolean;

-- check to see if the AOP Server is running (procedure returning with htp.p and dbms_output)
procedure is_aop_accessible(
  p_url             in varchar2,
  p_proxy_override  in varchar2 default null,
  p_wallet_path     in varchar2 default null,
  p_wallet_pwd      in varchar2 default null);


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
5181d e9f4
hao43ToyTTnAtZV+NFzl1n9f4fAwg83tOr8FhS18kj8QIhf5W3EuizdZEWCJQy4YwXYYRhTU
aOEJp41oz1eJNjFfPgmoPpb+kviaD+ogfZQRqRpdWGmG91oOmCMK4uLiDQ8gNDtPNhnMZELu
8Mm/s31IcRKkVRCSj3PSGiLOKfquro+atuSv0k7rtz+09jbXA3yl/O0/d3RK/9zyc022dDmm
BD+jTLtMAH5uPGrtnuEeiD+SmAZ4a6yxdEoeF81rsQD2xDsN9tU9GbomMwONJ7tkw/g68g0P
2MP4Q/INDzvD+IEntMKYCc2D8g3+K+VzfmOD+NU9P7wJzR/VPT++Cc3q1T0/7fLNTaQ0mYOh
zSMkMK7jkTIEDRJJ0gDWbDRIFGSMK/5TFyBRiHSrOAokfoFFUKKMVdrxe+obGmhOgwnMFr/O
67eMjxo9AsR9Dx51/s6Wnegy1P1BOUwlLGuObJLhOqpOCsHqClz1wjCxCMAhQXYwvP5zmMYM
w0fW8Uo2Nhqd9v28ovlrkWI7XUFUwJY7XYItXQOg8fjg+nOg8XKV8XLr8rwvDLxa1ToJVjpl
O13VLV0KoPFklfFkXhc/6m460unl9Ole6vS2oXEhMlhX6dvpXrH0tyRxITJrVztq6V7qGLbf
cSEyJleUaulesRi3VnEhMi1XEBXpXupttu8W8ryJKGswUBw2SpiIf0IFADRVagUA5GrN7ki2
kJoHuF5qFzosUDj5ByQOC/gU54wcIti1yG6Dzh/F+79hI50Cuc9zxEk9t+OnKEWBjJ9QjkpC
l3ZaNNTdHjPnbaiUw4jw1njAlYQrL4VKnCv2H7OInQY6Z3knFcEA7k6C7k68pTq+pToCpTpj
pTqNpToNtDxIJYBSozohXV33pX2lRyuzLKLMB6/4a8HdpIjzayyyq+0iSca8O44n79iEPt7g
2SXSFzNyort4BdVl7uBsmxid3U10mo8LFb7lTV/qbPLbtuFF5mORMhg7EaUiEW6y87TcSRFh
/H23qoiqBK76kQEyOZQIDFu/s3k0VF8i25S7j0gfPz2PsRzkIzmdM+6xx86B4T/tRg9kj7H2
cXXDrzInUwmyseXuJypxZEDVPLjXq+KjajKMoeStQY+usQgGJyK8ukoX65trH65kKBDVcwg0
AzUKEvH0xLi0an/LWyF27bhNFVK9W6h2Urgwry1GKHbPiY+E4beqWbR/+tTbBLeTWWd/3hoM
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
pSUGySVh51xoFdq9csu1T7UsspWCXg==

/
create or replace package aop_plsql19_pkg
AUTHID CURRENT_USER
as

/* Copyright 2015-2019 - APEX RnD
*/

/* AOP Version */
c_aop_version  constant varchar2(5)   := '19.2';

--
-- Pre-requisites: apex_web_service package
-- if APEX is not installed, you can use this package as your starting point
-- but you would need to change the apex_web_service calls by utl_http calls or similar
--


--
-- Change following variables for your environment
--
g_aop_url  varchar2(200) := 'http://api.apexofficeprint.com/';                  -- for https use https://api.apexofficeprint.com/
g_api_key  varchar2(200) := '';    -- change to your API key in APEX 18 or above you can use apex_app_setting.get_value('AOP_API_KEY')
g_aop_mode varchar2(15)  := null;  -- AOP Mode can be development or production; when running in development no cloud credits are used but a watermark is printed                                                    

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
  p_aop_mode         in varchar2 default g_aop_mode,  
  p_json             in clob,
  p_template         in blob,
  p_template_type    in varchar2 default null,
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
  p_aop_mode         in varchar2 default g_aop_mode,
  p_json             in clob,
  p_template         in blob,
  p_template_type    in varchar2 default null,
  p_output_encoding  in varchar2 default 'raw',  
  p_output_type      in varchar2 default null,
  p_output_filename  in varchar2 default 'output',
  p_aop_remote_debug in varchar2 default 'No')
  return blob
as
  l_output_converter  varchar2(20) := ''; --default
  l_aop_json          clob;
  l_template_clob     clob;
  l_template_type     varchar2(10);
  l_data_json         clob;
  l_output_type       varchar2(10);
  l_blob              blob;
  l_error_description varchar2(32767);
begin
  l_template_clob := apex_web_service.blob2clobbase64(p_template);
  l_template_clob := replace(l_template_clob, chr(13) || chr(10), null);
  l_template_clob := replace(l_template_clob, '"', '\u0022');

  if p_template_type is null 
  then
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
  else
      l_template_type := p_template_type;
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
      "mode": "***AOP_MODE***",
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
  l_aop_json := replace(l_aop_json, '***AOP_MODE***', p_aop_mode);
  l_aop_json := replace(l_aop_json, '***AOP_REMOTE_DEBUG***', p_aop_remote_debug);
  l_aop_json := replace_with_clob(l_aop_json, '***AOP_TEMPLATE_BASE64***', l_template_clob);
  l_aop_json := replace_with_clob(l_aop_json, '***AOP_TEMPLATE_TYPE***', l_template_type);
  l_aop_json := replace(l_aop_json, '***AOP_OUTPUT_ENCODING***', p_output_encoding);
  l_aop_json := replace(l_aop_json, '***AOP_OUTPUT_TYPE***', l_output_type);
  l_aop_json := replace(l_aop_json, '***AOP_OUTPUT_CONVERTER***', l_output_converter);
  l_aop_json := replace_with_clob(l_aop_json, '***AOP_DATA_JSON***', l_data_json);
  l_aop_json := replace(l_aop_json, '\\n', '\n');

  --logger.log(p_text  => 'AOP JSON: ' || p_message, p_scope => 'AOP', p_extra => l_aop_json);

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
c_aop_version             constant varchar2(5) := '19.2';
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
