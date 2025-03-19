cask "nethlink" do
  version "1.0.2"
  sha256 "5109f6bdf6f9585dd22689cd469e836e1364cf376f3bb609fa58707bbbc49d17"

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