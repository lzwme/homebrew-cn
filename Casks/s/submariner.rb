cask "submariner" do
  version "3.3"
  sha256 "3383aa779103cea390a6c89525abf3514be814d5f953031c5a00083fcde13219"

  url "https:github.comNattyNarwhalSubmarinerreleasesdownloadv#{version}Submariner-#{version}.zip",
      verified: "github.comNattyNarwhalSubmariner"
  name "Submariner"
  desc "Subsonic client"
  homepage "https:submarinerapp.com"

  depends_on macos: ">= :monterey"

  app "Submariner.app"

  zap trash: [
    "~LibraryApplication Scriptsfr.read-write.Submariner",
    "~LibraryContainersfr.read-write.Submariner",
    "~MusicSubmariner",
  ]
end