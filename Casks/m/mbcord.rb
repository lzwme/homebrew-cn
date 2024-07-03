cask "mbcord" do
  version "2.3.13"
  sha256 "2640e50aa5d0f8eccc3697700841667b0b5cfb83df33679ed260d468f559334d"

  url "https:github.comoonqtMBCordreleasesdownload#{version}MBCord-darwin-x64.zip"
  name "mbcord"
  desc "Discord rich presence client for Jellyfin and Emby"
  homepage "https:github.comoonqtMBCord"

  app "MBCord.app"

  caveats do
    requires_rosetta
  end
end