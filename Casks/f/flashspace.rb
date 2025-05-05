cask "flashspace" do
  version "3.5.43"
  sha256 "83559ac1e85483c7da8e3b97668cba5d653ac0e89d2331b388136733052eb194"

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