cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.60.29"
  sha256 arm:   "0c1144110a615d17b2d9ac835223c5599a0a7e0f0db8db318afd29af1821ddae",
         intel: "31bc20f51e0060fb1e230ddc64897e5eb4f50e789efc168753b215571ca3601d"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end