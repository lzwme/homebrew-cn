cask "font-iosevka-ss13" do
  version "27.2.1"
  sha256 "df79a0fbccf9b7cd7e7e6a777a4fda6fd54c9d0745c9d2b487c67352a0439957"

  url "https://ghproxy.com/https://github.com/be5invis/Iosevka/releases/download/v#{version}/ttc-iosevka-ss13-#{version}.zip"
  name "Iosevka SS13"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "iosevka-ss13-bold.ttc"
  font "iosevka-ss13-extrabold.ttc"
  font "iosevka-ss13-extralight.ttc"
  font "iosevka-ss13-heavy.ttc"
  font "iosevka-ss13-light.ttc"
  font "iosevka-ss13-medium.ttc"
  font "iosevka-ss13-regular.ttc"
  font "iosevka-ss13-semibold.ttc"
  font "iosevka-ss13-thin.ttc"

  # No zap stanza required
end