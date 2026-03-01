cask "font-iosevka" do
  version "34.2.0"
  sha256 "836618cba53fd3e881aef09c3d33242ab83dadccb11c9ca74d66325bb866cf79"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka.ttc"

  # No zap stanza required
end