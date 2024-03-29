cask "itubedownloader" do
  version "6.6.0"
  sha256 :no_check

  url "https://itubedownloader.s3.us-east-2.amazonaws.com/iTubeDownloader.dmg",
      verified: "itubedownloader.s3.us-east-2.amazonaws.com/"
  name "iTubeDownloader"
  desc "Download YouTube videos, channels, or playlists"
  homepage "https://alphasoftware.co/"

  livecheck do
    url "https://itubedownloader.s3.us-east-2.amazonaws.com/appcast.xml"
    strategy :sparkle, &:short_version
  end

  app "iTubeDownloader.app"
end