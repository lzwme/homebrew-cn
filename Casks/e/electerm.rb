cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.72.6"
  sha256 arm:   "7aca87d93e6f7358ed9b39c409d0c5de5152f82788fb89f1746a49f8b44d439e",
         intel: "89e5413d7bb9338b264b5f870885a2d8a1d8bcc93c1e5bcd4ea5ff94b77054fc"

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