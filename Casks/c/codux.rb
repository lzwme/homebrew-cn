cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.29.0"
  sha256 arm:   "20de2ab695b8fe8bbdc142e11291dc9ab1ee99e7658574bad12531982678760b",
         intel: "0da74180eb701bd4d7245e7a697671f50fb037b269217ade6de3b6b0397fba13"

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