cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.37.3"
  sha256 arm:   "49d1e1b53cdbf535d97874897722bbccdde1065712c4a593a73fbd7f0455c2bd",
         intel: "6530932ac866f0ff2adae0545686238004e153e1c5b60facf8bbc46b5d4c141c"

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