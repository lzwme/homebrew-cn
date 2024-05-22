cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.27.0"
  sha256 arm:   "503596614da78acc7c42b0f08b7c1b986c97e410142b052a01524aabf23ce4b9",
         intel: "f77906dc5bc7f0af64cbd7daaf374d1cf4fbb2dc0d5ad90942f4c49984a2630f"

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