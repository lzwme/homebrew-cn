cask "switchkey" do
  version "1.1.3"
  sha256 "a8a62231adddffc954a894b7fd00051d903de31a0e37d68787425bdc287399c8"

  url "https:github.comitsuhaneSwitchKeyreleasesdownloadv#{version}SwitchKey.zip"
  name "SwitchKey"
  homepage "https:github.comitsuhaneSwitchKey"

  no_autobump! because: :requires_manual_review

  app "SwitchKey.app"

  zap trash: "~LibraryPreferencesitsuhane.tools.SwitchKey.plist"
end