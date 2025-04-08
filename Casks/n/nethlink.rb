cask "nethlink" do
  version "1.1.0"
  sha256 "9d3682d87b2362e25fb6f930c84dfbdfb6795507f36ede70bd9751746b8971f4"

  url "https:github.comNethServernethlinkreleasesdownloadv#{version}nethlink-#{version}.dmg"
  name "NethLink"
  desc "Link NethServer systems and provide remote access tools"
  homepage "https:github.comNethServernethlink"

  depends_on macos: ">= :catalina"

  app "NethLink.app"

  zap trash: "~LibraryApplication Supportnethlink"

  caveats do
    requires_rosetta
  end
end