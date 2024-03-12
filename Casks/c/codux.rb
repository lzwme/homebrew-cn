cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.22.0"
  sha256 arm:   "b3665497486f6b08db15254ffdf0c221993272d009d541e0b71ae384059b97ce",
         intel: "af67f6728e382de12c96cf4a10df035a340e52e5e620df7c1805fb9dadfbd6bd"

  url "https:github.comwixplosivescodux-versionsreleasesdownload#{version}Codux-#{version}.#{arch}.dmg",
      verified: "github.comwixplosivescodux-versions"
  name "Codux"
  desc "React IDE built to visually edit component styling and layouts"
  homepage "https:www.codux.com"

  livecheck do
    url "https:www.codux.comdownload"
    regex(href=.*?Codux[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :catalina"

  app "Codux.app"

  zap trash: [
    "~LibraryApplication SupportCodux",
    "~LibraryPreferencescom.wixc3.wcs.plist",
    "~LibrarySaved Application Statecom.wixc3.wcs.savedState",
  ]
end