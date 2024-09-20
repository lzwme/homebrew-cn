cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.40.6"
  sha256 arm:   "f5851fe377ea4dc08a39b5efbad89d8a293a7947926f22388411bee9eee6cf13",
         intel: "98be090de76496d6c9f49b7ec9805a57222c9872bfc890a0d8272ec983d1c06d"

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