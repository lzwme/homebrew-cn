cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.41.0"
  sha256 arm:   "921b414a41ea1adea4b46ef1d82989d798d3fef7ecae88d986d82ee17674b7cb",
         intel: "ddc48e34962de549b0e1811327247f1adefb425416b8e7293245269b72d57958"

  url "https:github.comwixplosivescodux-versionsreleasesdownload#{version}Codux-#{version}.#{arch}.dmg",
      verified: "github.comwixplosivescodux-versions"
  name "Codux"
  desc "React IDE built to visually edit component styling and layouts"
  homepage "https:www.codux.com"

  livecheck do
    url "https:www.codux.comdownload"
    regex(href=.*?Codux[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :big_sur"

  app "Codux.app"

  zap trash: [
    "~LibraryApplication SupportCodux",
    "~LibraryPreferencescom.wixc3.wcs.plist",
    "~LibrarySaved Application Statecom.wixc3.wcs.savedState",
  ]
end