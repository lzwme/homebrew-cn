cask "finicky" do
  version "4.1.1"
  sha256 "e423f5ba224ffe1d9cfa1340143a1496e602ab155aeeffbe59b9b0b1094fd3e7"

  url "https:github.comjohnstefinickyreleasesdownloadv#{version}Finicky.dmg"
  name "Finicky"
  desc "Utility for customizing which browser to start"
  homepage "https:github.comjohnstefinicky"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Finicky.app"

  zap trash: "~LibraryPreferencesse.johnste.finicky.plist"
end