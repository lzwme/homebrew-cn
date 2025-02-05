cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.60.32"
  sha256 arm:   "6b702688a22b06e0eacaf1ab577279482fe51af9229f730e9768c1cc8a4f27dc",
         intel: "f965c02ad6944f8322c33542ca8fbc73a28705c8c5349012942ef4ae3f29886c"

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