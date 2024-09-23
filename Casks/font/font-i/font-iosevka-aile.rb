cask "font-iosevka-aile" do
  version "31.7.1"
  sha256 "a15a4717019edf0c1ac59e9d7d11ebd8eb48e05d58e3017da1b0fe190bdd3df7"

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