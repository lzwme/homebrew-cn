cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.76"
  sha256 arm:   "4b861491dd7602ed76a428c42f6a2e99200aa7218bf8ae109a5bbce2e7e29b9b",
         intel: "7353198145089e318af310a3c69624456513b27830f50f438574dc2f01f84fd0"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end