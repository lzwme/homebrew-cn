cask "font-iosevka-curly" do
  version "33.2.0"
  sha256 "3f133e48921d73159ed7d9e0660a40ee81f94fb3d166033ce8005fc3ea0305b8"

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