cask "spatterlight" do
  version "1.2.5"
  sha256 "e392f54e3cbb0d2ca7ba2119227765704d5e6f4303a6880bedf402f34efad6c7"

  url "https:github.comangstsmurfspatterlightreleasesdownloadv#{version}Spatterlight.zip",
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