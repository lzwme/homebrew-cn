cask "font-iosevka-ss16" do
  version "33.2.6"
  sha256 "d19062a57d2ba455589acdd3e45f0c66db823ad48d9bed9db97236c91359ba21"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end