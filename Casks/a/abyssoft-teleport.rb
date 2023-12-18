cask "abyssoft-teleport" do
  version "1.3.5"
  sha256 "2fbb28b2ffe884521b222509b59f1006b751325922b936acb974d36a6622d897"

  url "https:github.comabyssoftteleportreleasesdownloadv#{version}teleport-v#{version}.zip"
  name "teleport"
  desc "Virtual KVM"
  homepage "https:github.comabyssoftteleport"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "teleport.app"

  zap trash: [
    "~LibraryCachescom.abyssoft.teleport",
    "~LibraryPreferencescom.abyssoft.teleport.plist",
  ]
end