cask "flashspace" do
  version "0.13.15"
  sha256 "17eb7c66be17464f612fe4bab9988fba34854093a3fd4c96b1d195ff674afe2c"

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