name			 "sample-app"
maintainer       "tkn"
maintainer_email "tkn@zuehlke.com"
license          "All rights reserved"
description      "A minimal sample application cookbook"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "apache2",  "1.5.0"
depends "apt",      "1.3.2"