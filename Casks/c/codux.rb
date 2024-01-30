cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.19.0"
  sha256 arm:   "c0396e63b4521104b3e0d40b22fdcecf4853a622782ff73b477b63b95c8705cb",
         intel: "c7daf5849f2b8e79c806eebfd52edad38abc1371fa44638576d68456399cb254"

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