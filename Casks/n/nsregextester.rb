cask "nsregextester" do
  version "1.0"
  sha256 :no_check

  url "https:raw.githubusercontent.comaaronveghnsregextestermasterNSRegexTester.zip",
      verified: "raw.githubusercontent.comaaronveghnsregextestermaster"
  name "NSRegexTester"
  homepage "https:github.comaaronveghnsregextester"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "NSRegexTester.app"
end