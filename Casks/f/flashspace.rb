cask "flashspace" do
  version "2.2.27"
  sha256 "9772ffd708dfc61b660dc4a76f9915714b95df2173ef1734f821fc96607ba369"

  url "https:github.comwojciech-kulikFlashSpacereleasesdownloadv#{version}FlashSpace.app.zip"
  name "FlashSpace"
  desc "Virtual workspace manager"
  homepage "https:github.comwojciech-kulikFlashSpace"

  depends_on macos: ">= :sonoma"

  app "FlashSpace.app"

  uninstall quit: "pl.wojciechkulik.FlashSpace"

  zap trash: [
    "~LibraryApplication Scriptspl.wojciechkulik.FlashSpace",
    "~LibraryAutosave Informationpl.wojciechkulik.FlashSpace.plist",
    "~LibraryCachespl.wojciechkulik.FlashSpace",
    "~LibraryHTTPStoragespl.wojciechkulik.FlashSpace",
    "~LibraryPreferencesFlashSpace.plist",
    "~LibraryPreferencespl.wojciechkulik.FlashSpace.plist",
    "~LibrarySaved Application Statepl.wojciechkulik.FlashSpace.savedState",
  ]
end