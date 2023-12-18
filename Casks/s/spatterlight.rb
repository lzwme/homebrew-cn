cask "spatterlight" do
  version "1.1"
  sha256 "fbce044a905de31e6b46456cac5870447ccda16c427f622e7edbaa85901ea886"

  url "https:github.comangstsmurfspatterlightreleasesdownloadv#{version}Spatterlight.zip",
      verified: "github.comangstsmurfspatterlight"
  name "Spatterlight"
  desc "Play most kinds of interactive fiction game files"
  homepage "https:ccxvii.netspatterlight"

  depends_on macos: ">= :catalina"

  app "Spatterlight.app"

  zap trash: [
    "~LibraryApplication Scriptsnet.ccxvii.spatterlight.*",
    "~LibraryContainersnet.ccxvii.spatterlight.*",
    "~LibraryPreferencesnet.ccxvii.spatterlight.plist",
  ]
end