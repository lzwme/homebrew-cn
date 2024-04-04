cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.24.0"
  sha256 arm:   "679e9d2c4916a6f4aec98183a2c91fa80f126d1f27075d6092e4274bbf566b3d",
         intel: "13b9f92fd8d11271544f6035e5a088478768189880745dfbc770e77b329273fe"

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