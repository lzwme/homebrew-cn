cask "hammerspoon" do
  on_mojave :or_older do
    version "0.9.93"
    sha256 "eb4eb4b014d51b32ac15f87050eb11bcc2e77bcdbfbf5ab60a95ecc50e55d2a3"

    url "https:github.comHammerspoonhammerspoonfiles7707382Hammerspoon-#{version}-for-10.14.zip",
        verified: "github.comHammerspoonhammerspoon"

    # Specific build provided for Mojave upstream https:github.comHammerspoonhammerspoonissues3023#issuecomment-992980087
    livecheck do
      skip "Specific build for Mojave and earlier"
    end
  end
  on_catalina :or_newer do
    version "0.9.100"
    sha256 "6dcfc807c7cec692caf3b18c36cc1ea3af6b9f42699b4df277734408e4e07399"

    url "https:github.comHammerspoonhammerspoonreleasesdownload#{version}Hammerspoon-#{version}.zip",
        verified: "github.comHammerspoonhammerspoon"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  name "Hammerspoon"
  desc "Desktop automation application"
  homepage "https:www.hammerspoon.org"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Hammerspoon.app"
  binary "#{appdir}Hammerspoon.appContentsFrameworkshshs"

  uninstall quit: "org.hammerspoon.Hammerspoon"

  zap trash: [
    "~.hammerspoon",
    "~LibraryApplication Supportcom.crashlyticsorg.hammerspoon.Hammerspoon",
    "~LibraryCachesorg.hammerspoon.Hammerspoon",
    "~LibraryPreferencesorg.hammerspoon.Hammerspoon.plist",
    "~LibrarySaved Application Stateorg.hammerspoon.Hammerspoon.savedState",
  ]
end