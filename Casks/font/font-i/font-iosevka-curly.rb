cask "font-iosevka-curly" do
  version "31.8.0"
  sha256 "1ee228437e621056a46845586136d2db0cbcea337851d1d450d5bdfe30e41cf0"

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