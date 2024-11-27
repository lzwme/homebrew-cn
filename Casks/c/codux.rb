cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.38.0"
  sha256 arm:   "9fb0f9c41d795f182ebd93a457b44df2a181056fe31692fb99056b0c3907a2e8",
         intel: "855fa54fd9eb85e2062969a66e0187b3a4880c9f989cefc5539cb1cfe9280aa6"

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