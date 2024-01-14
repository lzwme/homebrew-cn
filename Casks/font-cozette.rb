cask "font-cozette" do
  version "1.23.2"
  sha256 "86d589a35fdb54ad5f0abfa62ecc8d38721a02b1e87522fb52b81a46a6c203c5"

  url "https:github.comslavfoxCozettereleasesdownloadv.#{version}CozetteVector.dfont"
  name "Cozette"
  desc "Bitmap programming font"
  homepage "https:github.comslavfoxCozette"

  font "CozetteVector.dfont"

  # No zap stanza required
end