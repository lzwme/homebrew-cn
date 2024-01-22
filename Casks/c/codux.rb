cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.18.2"
  sha256 arm:   "77028bcb59183d05ca342b885953a49e8a57f12484b869e9d74c59c88572840d",
         intel: "6357704a6da056a7cf44b057f69f356d4fe1a6a08d739a6c091da6c054aa9a3f"

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