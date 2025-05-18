cask "font-iosevka-curly" do
  version "33.2.3"
  sha256 "8ee348807318d12a7eab10551677de530f16053934492baaf466ce3106d108a0"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurly-#{version}.zip"
  name "Iosevka Curly"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurly.ttc"

  # No zap stanza required
end