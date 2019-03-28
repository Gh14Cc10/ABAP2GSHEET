# Description

This project comprises an archive containing a framework and sample source codes for the integration of Google Sheets with SAP Netweaver component.

# Minimum Requirements

- This functionality is only available for SAP NetWeaver starting from AS ABAP 7.40 SP08 (Note 2043775 must be applied)

# Download and Installation

## Proceed as follows to make best use of the sample code:

1. Clone the repository via ABAPGIT.
2. Setup the Google API Endpoint (see chapter 2.2 in [Export of ALV Grid Data to Google Sheets](https://www.sap.com/documents/2018/07/56e0dd6d-0f7d-0010-87a3-c30de2ffd8ff.html) )

NOTE
As a prerequisite, the redirection URI of the AS ABAP must be reachable from the internet. Google will
check this during the registration process. If your AS ABAP is reachable from the internet, you may
skip the below described steps of this chapter. Otherwise proceed as follows:
- Open a command shell. On a Windows system, this can be done by means of command cmd.
- Run the following command:
ping <hostname of your AS ABAP Development System>
- Note down the returned IP address.
- Edit the hosts file as administrator. On a windows system, this file is located at the following path:
C:\Windows\System32\drivers\etc\hosts
- Map the IP to a fake top level domain name, by adding a new line to the hosts file.
<IP ADDRESS NOTED IN STEP 3> <YOUR TOP LEVEL DOMAIN>
Example: 10.66.51.74 dev.yourtopleveldomain.com


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
