cask "submariner" do
  version "3.1"
  sha256 "5d44638cca45f6d17c64af875bbf7c3ea224e442b556c7ed4d9f181a731d41c2"

  url "https:github.comNattyNarwhalSubmarinerreleasesdownloadv#{version}Submariner-#{version}.zip",
      verified: "github.comNattyNarwhalSubmariner"
  name "Submariner"
  desc "Subsonic client"
  homepage "http:submarinerapp.com"

  depends_on macos: ">= :big_sur"

  app "Submariner.app"

  zap trash: [
    "~LibraryApplication Scriptsfr.read-write.Submariner",
    "~LibraryContainersfr.read-write.Submariner",
    "~MusicSubmariner",
  ]
end