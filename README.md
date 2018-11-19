# Description

This project comprises an archive containing a framework and sample source codes for the integration of Google Sheets with SAP Netweaver component.

# Minimum Requirements

- This functionality is only available for SAP NetWeaver starting from AS ABAP 7.40 SP08 (Note 2043775 must be applied)

# Download and Installation

## Proceed as follows to make best use of the sample code:

1. Clone the repository via ABAPGIT.
2. Setup the Google API Endpoint (see chapter 2.2 in [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html) )
3. Create a Service Provider Type for Google (see chapter 2.3.1 [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))
4. Create an OAuth 2.0 Client Profile (see chapter 2.3.6 [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))
5. Configure the Access to Google APIs (see chapter 2.4 [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))
6. Check the Connection (see chapter 2.5. [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))


# Configuration Guide

See the full documentation [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html) available in the SAP Community.

# Known Issues

None.
# Class and method list
- ZCL_FILE_API
  - COPY: Copies a file to a new location
  - DELETE: Deletes a Google drive file
  - LIST_FILTER: Lists user's file based on filter specified
- ZCL_DRIVE_PERMISSON_API
  - CREATE:  Creates a permission for a file
  - DELETE: Deletes a permission
  - GET_ALL: Gets a permission info by ID
- ZCL_GSPREADSHEET_API
   - BATCH_UPDATE: Applies one or more updates to the spreadsheet
   - CREATE_NEW_SPREADSHEET: Creates a new spreadsheet and returns it back
   - GET_SPREADSHEET: Returns the spreadsheet at the given ID  
   - GET_SPREADSHEET_FILTER: Returns the spreadsheet at the given ID with data filter with constraints specified
   - ZCL_GSPREADSHEET_SHEETS_API
   - COPY_SHEETS: Clones the sheet specified into a new one  in the same document
- ZCL_GSPREADSHEET_VALUES_API:
   - BATCH_APPEND: Appends  multiple range  values after the range specified or the  last filled cell ( range is optional)
   - BATCH_CLEAR: Clears multiple ranges of values from the spreadsheet
   - BATCH_GET: Returns multiple ranges of values from the spreadsheet
   - BATCH_UPDATE: Sets values in multiple ranges of the spreadsheet
   - GET: Returns a single range of values from the spreadsheet
   - APPEND: Appends  multiple values after the specified range  or the last filled cell
- ZCL_GOOGLE_HTTP_API: Basic low level method useful to operate with Google apis
   - EXTRACT_SPREADSHEET_ID: Extracts the file identifier from url
   - SEND_DELETE_REQUEST: Sends a HTTP delete request
   - DISPLAY_RESPONSE: Displays request response to user
   - SEND_POST_REQUEST: Sends a HTTP post request
   - SEND_GET_REQUEST: Sends a HTTP get request
   - EXTRACT_RESPONSE: Extracts response string from a response object
   - ENCODE_JSON2ABAP: Encodes a json string  as abap data object
   - DECODE_ABAP2JSON: Decodes an abap data object and returns it  as a json string



# Reading & Writing Cell Values
Spreadsheets can have multiple sheets, with each sheet having any number of rows or columns. A cell is a location at the intersection of a particular row and column, and may contain a data value. The Google Sheets API provides the spreadsheets.values collection to enable the simple reading and writing of values.

This page describes the basics of using the spreadsheets.values collection. In Abap2Gsheet you can use the ZCL_GSPREADSHEET_VALUES_API class method.

If you need to update formatting or other properties in a sheet, you will need to use the spreadsheets collection. In Abap2Gsheet you can use the  ZCL_GSPREADSHEET_API class method.

# Basic Reading 
The Sheets API allows you to read values from cells, ranges, sets of ranges and entire sheets. The examples on this page illustrate how some common read operations can be achieved with the spreadsheets.values collection of this API. You can also read cell values using the spreadsheets.get method, but in most cases using spreadsheets.values.batchGet is easier to use.

In Abap2Gsheet Values.batchGetmethod is available as a method of class ZCL_GSPREADSHEET_VALUES_API.

# Basic Writing
The Sheets API allows you to write values and formulas to cells, ranges, sets of ranges and entire sheets

Note that is also possible to write cell values using the spreadsheet.batchUpdate method, which can be useful if you want to simultaneously update cell formatting or other properties that the spreadsheets.values collection does not affect. However, for simple value writes it is easier to use  spreadsheets.values.batchUpdate.

In Abap2Gsheet Values.batchUpdate method is available as a method of class ZCL_GSPREADSHEET_VALUES_API.

# Write to multiple ranges
Starting with a blank sheet, the following spreadsheets.values.batchUpdate request will write values from the ranges Sheet1!I18:I21, and Sheet1!J18:J21. Existing values in the target range will be overwritten

 
```ABAP
REPORT ZGOOGLE_BATCH_UPD_VALUE.
p_url = 'spreadsheet link'.
p_range = 'I18:I21'.
p_range2 = 'J18-J21'.
DATA:

*Request object
lv_request_obj    type ref to ZCL_GSHEET_BATCH_VALUE_REQ,
*Request structure
ls_request        type ZGSHEET_BATCH_UPDATE_VAL_REQ_S,

*Values structure
lt_values         TYPE TABLE OF ZGSHEET_STRING_TT,
ls_value          LIKE LINE OF lt_values,
*Range structure
ls_value_range    type ZGSHEET_VALUE_RANGES_S,
ls_value_string   LIKE LINE OF lt_values,

lv_spreadsheet_id type string.
lv_spreadsheet_id = ZCL_GSHEET_UTILITY=>EXTRACT_SPREADSHEET_ID( ip_url = p_url ).

CREATE OBJECT lv_request_obj type ZCL_GSHEET_BATCH_VALUE_REQ.


APPEND 'testValues3' TO ls_value.
APPEND   ls_value TO  lt_values.
CLEAR: ls_value_string,
        ls_value.


APPEND 'testValues4' TO ls_value.
APPEND   ls_value TO  lt_values.


CLEAR: ls_value_string,
        ls_value.

APPEND 'testValues5' TO ls_value.
APPEND   ls_value TO  lt_values.

*range1
ls_value_range-RANGE = p_range1.
ls_value_range-VALUES = lt_values .
APPEND ls_value_range  TO ls_request-DATA.
CLEAR ls_value.
*range2
ls_value_range-RANGE = p_range2.
ls_value_range-VALUES = lt_values .
APPEND ls_value_range  TO ls_request-DATA.
CLEAR ls_value.

ls_request-VALUE_INPUT_OPTION = 'USER_ENTERED'.

lv_request_obj->ADD_REQUEST( IP_REQUEST = ls_request  ).
lv_request_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id
    IP_SHEET_ID       = '0'
).
```

 

# Updating Spreadsheets properties
Aside from the data contained in its cells, a spreadsheet includes many other types of data, such as:

Cell formats
Cell borders
Named ranges
Protected ranges
Conditional formatting
These are just some of the many kinds of data that control the appearance and operation of a spreadsheet. The  batchUpdate method lets you update any of these spreadsheet details. Changes are grouped together in a batch so that if one request fails, none of the other (potentially dependent) changes is written.

Refer to the google doc. page for all method available: BatchUpdate request method option

In Abap2Gsheet batchUpdate  is available as a method of class ZCL_GSPREADSHEET_API.  Each update need a structured request filled with the changes needed.

The list of method available with abap2Gsheet

BatchUpdate Method implemented:
REPEAT_CELL: Repeats a single cell across a range
UPDATE_BORDERS: Updates the borders in a range of cells.
ADD_PROTECTED_RANGE: Adds a protected range.
ADD_SHEET: Add new sheet
DELETE_SHEET: Delete a sheet by its ID and spreadsheet ID
UPDATE_SPREADSHEET: Updates the spreadsheet's properties.
UPDATE_SHEET: Updates a sheet's properties. (Eg. background Color)
ADD_CONDITIONAL_FORMATTING:  Add rule for conditional formatting
Sample Edit Cell Borders json
```JSON
Json update sample
{
  "requests": [
    {
      "updateBorders": {
        "range": {
          "sheetId": sheetId,
          "startRowIndex": 0,
          "endRowIndex": 10,
          "startColumnIndex": 0,
          "endColumnIndex": 6
        },
        "top": {
          "style": "DASHED",
          "width": 1,
          "color": {
            "blue": 1.0
          },
        },
        "bottom": {
          "style": "DASHED",
          "width": 1,
          "color": {
            "blue": 1.0
          },
        },
        "innerHorizontal": {
          "style": "DASHED",
          "width": 1,
          "color": {
            "blue": 1.0
          },
        },
      }
    }
  ]
}
``` 
Sample report that perform the edit cell border through Abap2Gsheet
```ABAP
REPORT ZGOOGLE_DEMO_UPDATE_FORMAT.
DATA p_url  type STRING.
p_url = 'https://docs.google.com/spreadsheets/d/1oMlGp8Jqd7v0P2QVIHpAI6wdIAzEP_fLZpYVkEt3dLM/edit#gid=0'.
DATA:
      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S,
      lv_batch_req_obj type ref to ZCL_GSHEET_BATCH_REQ,
      ls_range_object type ZGSHEET_GRID_RANGE_S,
      ls_border_object type ZGSHEET_BORDER_S,
      lv_spreadsheet_id type string.
      lv_spreadsheet_id = ZCL_GOOGLE_HTTP_API=>EXTRACT_SPREADSHEET_ID( ip_url = p_url ).
*Create an batch request instance
CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.

ls_range_object-SHEET_ID = '0'.
ls_range_object-START_ROW_INDEX = 0.
ls_range_object-END_ROW_INDEX = 10.
ls_range_object-START_COLUMN_INDEX = 0.
ls_range_object-END_COLUMN_INDEX = 6.
ls_request_batch-UPDATE_BORDERS-RANGE = ls_range_object.

ls_border_object-STYLE = 'DASHED'.
ls_border_object-COLOR-BLUE = '1.0'.
ls_request_batch-UPDATE_BORDERS-TOP = ls_border_object.
CLEAR ls_border_object.

ls_border_object-STYLE = 'DASHED'.
ls_border_object-COLOR-BLUE = '1.0'.
ls_request_batch-UPDATE_BORDERS-bottom = ls_border_object.
CLEAR ls_border_object.

ls_border_object-STYLE = 'DASHED'.
ls_border_object-COLOR-BLUE = '1.0'.
ls_request_batch-UPDATE_BORDERS-INNER_HORIZONTAL = ls_border_object.
CLEAR ls_border_object.


lv_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).

lv_batch_req_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id
    IP_SHEET_ID       = '0'
).
```

# Conditional Formatting
The Sheets API allows you to create and update the conditional formatting rules within spreadsheets. Only certain formatting types (bold, italic, strikethough, foreground color and background color) can be controlled through conditional formatting. The examples on this page illustrate how to achieve common conditional formatting operations with the API.

How to use conditional formatting with abap2Gsheet:

```ABAP 

*
PARAMETERS: p_url type string OBLIGATORY LOWER CASE.

DATA:


      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S,

      lv_batch_req_obj type ref to ZCL_GSHEET_BATCH_REQ,
      ls_range_object type ZGSHEET_GRID_RANGE_S,
      ls_border_object type ZGSHEET_BORDER_S,
      lv_spreadsheet_id type string.
lv_spreadsheet_id =  ZCL_GSHEET_UTILITY=>EXTRACT_SPREADSHEET_ID( ip_url = p_url ).

CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.
** Original json request
*{
*  "requests": [
*    {
*      "addConditionalFormatRule": {
*        "rule": {
*          "ranges": [
*            {
*              "sheetId": 0,
*              "startColumnIndex": 0,
*              "endColumnIndex": 8,
*      "startRowIndex":1,
*
*            },
*
*          ],
*          "booleanRule": {
*            "condition": {
*              "type": "CUSTOM_FORMULA",
*              "values": [
*                {
*                  "userEnteredValue": "=ISODD(ROW())"
*                }
*              ]
*            },
*            "format": {
*              "backgroundColor": {
*                "red": 1.05,
*                 "green": 1,
*                 "blue": 0.5,
*
*              }
*            }
*          }
*        },
*        "index": 0
*      }
*    }
*  ]
*}
CLEAR ls_request_batch.
DATA ls_value_condition type ZGSHEET_CONDITION_VALUE_S.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-SHEET_ID = '0'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-START_COLUMN_INDEX = 0.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-END_COLUMN_INDEX = 8.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-START_ROW_INDEX = 1.

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-CONDITION-type = 'CUSTOM_FORMULA'.

ls_value_condition-USER_ENTERED_VALUE = '=ISODD(ROW())'.
APPEND ls_value_condition TO
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-CONDITION-VALUES.
*ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-CONDITION-
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-FORMAT-background_Color-RED = '1.05'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-FORMAT-background_Color-GREEN = '1'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-FORMAT-background_Color-BLUE = '0.5'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-INDEX = 0.

lv_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
CLEAR ls_request_batch.

lv_batch_req_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id

).
```
# How to obtain support

Contact Alessandro Iannacci or Micael Teweldemedhin


# License
This framework is free and open source.

Sample code includes calls to the Google Drive APIs which calls are licensed under the Creative Commons Attribution 3.0 License _(_[_https://creativecommons.org/licenses/by/3.0/_](https://creativecommons.org/licenses/by/3.0/)_)_ in accordance with Google&#39;s Developer Site Policies _(_[_https://developers.google.com/terms/site-policies_](https://developers.google.com/terms/site-policies)_)._ Furthermore, the use of the Google Drive service is subject to applicable agreements with Google Inc.
