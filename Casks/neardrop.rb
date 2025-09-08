cask "neardrop" do
  version "2.2.0"
  sha256 "ee6fed09714487789f605198c0415bfd097b61efa527dd21560e10af5c56a6a5"

  url "https://ghfast.top/https://github.com/grishka/NearDrop/releases/download/v#{version}/NearDrop.app.zip"
  name "NearDrop"
  desc "Unofficial Google Nearby Share app"
  homepage "https://github.com/grishka/NearDrop"

  app "NearDrop.app"
end