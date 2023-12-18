cask "whichspace" do
  version "0.3.2"
  sha256 "8a59e12862af491de4c42413c839426c28dcb2f29138bfa2f45529c079119ce8"

  url "https:github.comgechrWhichSpacereleasesdownloadv#{version}WhichSpace.zip"
  name "WhichSpace"
  desc "Active space menu bar icon"
  homepage "https:github.comgechrWhichSpace"

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "WhichSpace.app"

  uninstall quit: "io.gechr.WhichSpace"

  zap trash: [
    "~LibraryCachesio.gechr.WhichSpace",
    "~LibraryCookiesio.gechr.WhichSpace.binarycookies",
    "~LibraryPreferencesio.gechr.WhichSpace.plist",
    "~LibrarySaved Application Stateio.gechr.WhichSpace.savedState",
  ]
end