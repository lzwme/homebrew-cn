cask "nsregextester" do
  version "1.0"
  sha256 :no_check

  url "https:raw.githubusercontent.comaaronveghnsregextestermasterNSRegexTester.zip",
      verified: "raw.githubusercontent.comaaronveghnsregextestermaster"
  name "NSRegexTester"
  homepage "https:github.comaaronveghnsregextester"

  deprecate! date: "2024-04-18", because: :unmaintained

  app "NSRegexTester.app"
end