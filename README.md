# Description

This project comprises an archive containing a framework and sample source codes for the integration of Google Sheets with SAP Netweaver component.

# Minimum Requirements

- This functionality is only available for certain SAP NetWeaver support packages, see [note 2592115](http://service.sap.com/sap/support/notes/2592115).
- After installation of the corresponding Support Package, it is **mandatory** to implement [note 2624404](http://service.sap.com/sap/support/notes/2624404) (ALV GUI: BAdi Export Integration Corrections).

# Download and Installation

## Proceed as follows to make best use of the sample code:

1. Clone the repository.
2. Setup the Google API Endpoint (see chapter 2.2 in [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html) )
3. Create a Service Provider Type for Google (see chapter 2.3.1 [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))
4. Create an OAuth 2.0 Client Profile (see chapter 2.3.6 [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))
5. Configure the Access to Google APIs (see chapter 2.4 [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))
6. Check the Connection (see chapter 2.5. [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html))


# Configuration Guide

See the full documentation [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html) available in the SAP Community.

# Known Issues

None.

# How to obtain support

Contact Alessandro Iannacci


# License
This framework is free and open source.

Sample code includes calls to the Google Drive APIs which calls are licensed under the Creative Commons Attribution 3.0 License _(_[_https://creativecommons.org/licenses/by/3.0/_](https://creativecommons.org/licenses/by/3.0/)_)_ in accordance with Google&#39;s Developer Site Policies _(_[_https://developers.google.com/terms/site-policies_](https://developers.google.com/terms/site-policies)_)._ Furthermore, the use of the Google Drive service is subject to applicable agreements with Google Inc.
