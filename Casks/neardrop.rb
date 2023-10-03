cask "neardrop" do
  version "2.0.2"
  sha256 "b270f084d2a25d3c3f7302112739898dbf6e1fd48b4b560d3f80b04c482f95a8"

  url "https://ghproxy.com/https://github.com/grishka/NearDrop/releases/download/v#{version}/NearDrop.app.zip"
  name "NearDrop"
  desc "Unofficial Google Nearby Share app"
  homepage "https://github.com/grishka/NearDrop"

  app "NearDrop.app"
end