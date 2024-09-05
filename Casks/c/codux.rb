cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.34.0"
  sha256 arm:   "983e92a4cbe4ce56ab01a88fcd309e2ad264b143724aa54712ebf9ca24840bc7",
         intel: "ebee01a73574559cd811986c37cca1e6d16a895beed989c04558f5db4ad839f2"

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