cask "beardie" do
  version "3.0.24.84.Release"
  sha256 "d4361bc06beab9e868b746695506656603febe02c32539ffc15a5a7b642425dd"

  url "https:github.comStillness-2beardiereleasesdownloadv#{version}Beardie.app.zip"
  name "Beardie"
  desc "Control various media players with your keyboard"
  homepage "https:github.comStillness-2beardie"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Beardie.app"

  zap trash: [
    "~LibraryCachescom.calm-apps.mac.beardie",
    "~LibraryPreferencescom.calm-apps.mac.beardie.plist",
  ]
end