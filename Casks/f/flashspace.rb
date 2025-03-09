cask "flashspace" do
  version "2.3.29"
  sha256 "ced62dfa55c1f562b33fab6cf684049936aa0e490ad3b3aae77a4c8897225d7d"

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