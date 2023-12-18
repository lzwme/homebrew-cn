cask "wkhtmltopdf" do
  version "0.12.6-2"
  sha256 "81a66b77b508fede8dbcaa67127203748376568b3673a17f6611b6d51e9894f8"

  url "https:github.comwkhtmltopdfpackagingreleasesdownload#{version}wkhtmltox-#{version}.macos-cocoa.pkg",
      verified: "github.comwkhtmltopdfpackaging"
  name "wkhtmltopdf"
  desc "HTML to PDF renderer"
  homepage "https:wkhtmltopdf.org"

  pkg "wkhtmltox-#{version}.macos-cocoa.pkg"

  uninstall pkgutil: "org.wkhtmltopdf.wkhtmltox",
            delete:  [
              "usrlocalbinwkhtmltoimage",
              "usrlocalbinwkhtmltopdf",
              "usrlocalincludewkhtmltox",
              "usrlocalliblibwkhtmltox.#{version.major_minor}.dylib",
              "usrlocalliblibwkhtmltox.#{version.major}.dylib",
              "usrlocalliblibwkhtmltox.#{version.sub(-.*$, "")}.dylib",
              "usrlocalliblibwkhtmltox.dylib",
            ],
            script:  {
              executable: "usrlocalbinuninstall-wkhtmltox",
              sudo:       true,
            }

  # No zap stanza required

  caveats do
    discontinued
    files_in_usr_local
  end
end