cask "font-cozette" do
  version "1.24.0"
  sha256 "c7be8ab37404073508b75e86ddcd7877a36e71f33c471edf04fc439b5aa7e41f"

  url "https:github.comslavfoxCozettereleasesdownloadv.#{version}CozetteVector.dfont"
  name "Cozette"
  desc "Bitmap programming font"
  homepage "https:github.comslavfoxCozette"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "CozetteVector.dfont"

  # No zap stanza required
end