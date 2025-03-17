cask "flashspace" do
  version "2.4.30"
  sha256 "abb7109675173d88530891c5b7bb83fe9bf312c916d9ec6c50b07323265fc5b3"

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