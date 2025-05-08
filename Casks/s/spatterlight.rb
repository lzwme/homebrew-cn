cask "spatterlight" do
  version "1.4.5"
  sha256 "0e3fc18e323fe6fe012dcbc674293c7411ae88dd8daaa65f7d0aa7ebf6bbbe1f"

  url "https:github.comangstsmurfspatterlightreleasesdownloadv#{version}Spatterlight.app.zip",
      verified: "github.comangstsmurfspatterlight"
  name "Spatterlight"
  desc "Play most kinds of interactive fiction game files"
  homepage "https:ccxvii.netspatterlight"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Spatterlight.app"

  zap trash: [
    "~LibraryApplication Scriptsnet.ccxvii.spatterlight.*",
    "~LibraryContainersnet.ccxvii.spatterlight.*",
    "~LibraryPreferencesnet.ccxvii.spatterlight.plist",
  ]
end