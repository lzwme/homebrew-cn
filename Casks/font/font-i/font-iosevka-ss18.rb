cask "font-iosevka-ss18" do
  version "34.2.0"
  sha256 "3134e77231317e438d25d7450bca4e1c28d1d57528faa8bb6e665244da5bf507"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18.ttc"

  # No zap stanza required
end