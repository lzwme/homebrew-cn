cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.17.2"
  sha256 arm:   "45f6223f167f2691a85e221169d681409cca6288ac55320cc054594f7417eea0",
         intel: "908e846f2c6ca28d509db42cc251eb02512cd849386730057cd99ab72384cb1c"

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