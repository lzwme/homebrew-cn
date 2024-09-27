cask "foxitreader" do
  version "2024.3"
  sha256 "bb2e2c6d42dfd3cf105736abe18bfe6134babc3f8e4b251ad54f91b054888c61"

  url "https://cdn78.foxitsoftware.com/pub/foxit/reader/desktop/mac/#{version.major}.x/#{version}/FoxitPDFReader#{version.no_dots}.L10N.Setup.pkg",
      verified: "cdn78.foxitsoftware.com/pub/foxit/reader/desktop/mac/"
  name "Foxit Reader"
  desc "PDF reader"
  homepage "https://www.foxit.com/pdf-reader/"

  livecheck do
    url "https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Mac-OS-X&language=English"
    strategy :header_match do |headers|
      match = headers["location"].match(%r{/(\d+\.\d)/FoxitPDFReader(\d+)\.L10N\.Setup\.pkg}i)
      next if match.blank?

      match[1]
    end
  end

  pkg "FoxitPDFReader#{version.no_dots}.L10N.Setup.pkg"

  uninstall launchctl: "com.foxit.PDFReaderUpdateService",
            pkgutil:   "com.foxit.pkg.pdfreader",
            delete:    "/Applications/Foxit PDF Reader.app"

  zap trash: [
    "/Library/LaunchDaemons/com.foxit.PDFReaderUpdateService.plist",
    "~/Library/Application Support/Foxit Software/Addon/Foxit PDF Reader",
    "~/Library/Application Support/Foxit Software/Foxit PDF Reader",
    "~/Library/Caches/com.foxit-software.Foxit PDF Reader",
    "~/Library/HTTPStorages/com.foxit-software.Foxit%20PDF%20Reader.binarycookies",
    "~/Library/Preferences/com.foxit-software.Foxit PDF Reader*",
    "~/Library/Preferences/Foxit Software",
    "~/Library/Saved Application State/com.foxit-software.Foxit PDF Reader.savedState",
  ]
end