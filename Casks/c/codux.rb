cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.21.0"
  sha256 arm:   "e742713684a6a7fc02a9355cf76f13e6372efa49b5cfa0622e908b5f5646b132",
         intel: "fdbb217e49ea429173510f1522e8370e8c53408f1d4e5a69514a3e6a501bb30e"

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