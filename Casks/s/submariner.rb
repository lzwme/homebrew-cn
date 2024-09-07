cask "submariner" do
  version "3.2.1"
  sha256 "81f40fc5de46f36739636182743d21dd75fd7ebc866ccb9873c358fefc43a299"

  url "https:github.comNattyNarwhalSubmarinerreleasesdownloadv#{version}Submariner-#{version}.zip",
      verified: "github.comNattyNarwhalSubmariner"
  name "Submariner"
  desc "Subsonic client"
  homepage "https:submarinerapp.com"

  depends_on macos: ">= :big_sur"

  app "Submariner.app"

  zap trash: [
    "~LibraryApplication Scriptsfr.read-write.Submariner",
    "~LibraryContainersfr.read-write.Submariner",
    "~MusicSubmariner",
  ]
end