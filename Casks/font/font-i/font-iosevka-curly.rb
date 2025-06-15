cask "font-iosevka-curly" do
  version "33.2.5"
  sha256 "0f244a33e5fbbaac4a57dd94268f38e8cf30baf6489bc7eab35936fc278b220c"

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