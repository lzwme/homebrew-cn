cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.20.0"
  sha256 arm:   "ac0e81b2d834c2105e73c76426aa5d2b96f9a789c44187e5ae891ce014820a0b",
         intel: "7bb690c3c6abbd57845cee9f7f35450359e5e8d2dc3ce33d882c2fb163848892"

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