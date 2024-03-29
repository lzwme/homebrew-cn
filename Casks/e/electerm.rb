cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.42"
  sha256 arm:   "f4ea3aac35048d6b86f85fd946e40d3916fc423ccec8ccd4428e3952c3f44702",
         intel: "de422ce72319a7a5393f93d32c0076e991bdc397ce4a92dbd0504dae567f0dd9"

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