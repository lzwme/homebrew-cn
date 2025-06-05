cask "finicky" do
  version "4.1.2"
  sha256 "044b20ac326546f799e7a4ed9a87672b9a86f92f16a5d57bc06c07201f3b27a5"

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