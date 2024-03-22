cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.23.0"
  sha256 arm:   "3ec5605a109a72faabd2fdd6189d4b81a5b9740b568ed3fd5851253a1fe4c8fb",
         intel: "9c242dec764810d6454d201df921dad06bd9308cae561acceed9745c92ae1be0"

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