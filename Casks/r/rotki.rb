cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.39.0"
  sha256 arm:   "030af9cba61f58cfc907fc289cebaaf30fa6f993cd9d1ae3b8f19ce6821c1280",
         intel: "ef9e54cfb6299214abd6875d58264eb1d8a1bb12cce41b8126ecb1dc20366eb0"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end