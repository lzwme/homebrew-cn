cask "airtrash" do
  version "1.0.0"
  sha256 "9ce83fef421654b4ca39550255dd09e0b2281da5fe3dbd9e8e23e58640912606"

  url "https:github.commaciejczyzewskiairtrashreleasesdownload#{version}airtrash-#{version}.dmg"
  name "airtrash"
  desc "Clone of Apple's Airdrop - easy P2P file transfer"
  homepage "https:github.commaciejczyzewskiairtrash"

  app "Airtrash.app"

  zap trash: [
    "~LibraryApplication Supportairtrash",
    "~LibraryPreferencesmaciejczyzewski.airtrash.plist",
  ]
end