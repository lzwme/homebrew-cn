cask "youtype" do
  version "0.7.3"
  sha256 :no_check

  url "https:github.comfreefeltYouTyperawmainYouType.zip"
  name "YouType"
  desc "Input method helper"
  homepage "https:github.comfreefeltYouType"

  livecheck do
    url "https:raw.githubusercontent.comfreefeltYouTypemainappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "YouType.app"

  uninstall quit: "com.AVKorotkov.YouType"

  zap trash: [
    "~LibraryCachescom.AVKorotkov.YouType",
    "~LibraryPreferencescom.AVKorotkov.YouType.plist",
  ]
end