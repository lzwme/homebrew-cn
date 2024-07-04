cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.30.0"
  sha256 arm:   "5bd510adbe4b5f4af4bab4f082837279649393c9d076912db54979f9228e0c6b",
         intel: "78fc8e0e6120596f155186db65fda60b45eaa86186a4c708f1d7362bc3347656"

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