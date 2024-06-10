cask "submariner" do
  version "3.1.1"
  sha256 "1354aba4ccf2912f44b5402b3f2295631358e44777614dc416749d2464a1e03b"

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