cask "hammerspoon" do
  on_mojave :or_older do
    version "0.9.93"
    sha256 "eb4eb4b014d51b32ac15f87050eb11bcc2e77bcdbfbf5ab60a95ecc50e55d2a3"

    url "https:github.comHammerspoonhammerspoonfiles7707382Hammerspoon-#{version}-for-10.14.zip",
        verified: "github.comHammerspoonhammerspoon"

    # Specific build provided for Mojave upstream https:github.comHammerspoonhammerspoonissues3023#issuecomment-992980087
    livecheck do
      skip "Specific build for Mojave and later"
    end
  end
  on_catalina :or_newer do
    version "1.0.0"
    sha256 "5db702b55da47dc306e8f5948d91ef85bebd315ddfa29428322a0af7ed7e6a7e"

    url "https:github.comHammerspoonhammerspoonreleasesdownload#{version}Hammerspoon-#{version}.zip",
        verified: "github.comHammerspoonhammerspoon"

    livecheck do
      url "https:raw.githubusercontent.comHammerspoonhammerspoonmasterappcast.xml"
      strategy :sparkle, &:short_version
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