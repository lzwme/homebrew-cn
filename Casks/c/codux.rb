cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.26.0"
  sha256 arm:   "7d28fa0b5f089b8273f97e44c46522378b769acfb078281ad9fdba41bcc1b452",
         intel: "aa209c0146ea6c0a7c63bc558aa75d6b0d3cdb68fc1780bcfd0229bcf11ed0bc"

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