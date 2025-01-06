cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.40.0"
  sha256 arm:   "13f24b8e70f24d1d80159deef9015d2cde30dddca00562114f352174c0131207",
         intel: "b86f1349f509bde5ba791b2661965f6eba756006bc28bd5fe8d273c1aa825f0a"

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