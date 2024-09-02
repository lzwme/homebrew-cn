cask "font-iosevka-aile" do
  version "31.5.0"
  sha256 "4116f1ed3c0e62eb8c1ce415e1c782ba725e53acbe099f4dc4167e5137a74d5b"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end