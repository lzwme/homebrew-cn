cask "font-iosevka-ss04" do
  version "26.0.2"
  sha256 "e3f32104166ad9bbe97745531785ccee65b00a0a0a5387f63724687c9b8f9032"

  url "https://ghproxy.com/https://github.com/be5invis/Iosevka/releases/download/v#{version}/ttc-iosevka-ss04-#{version}.zip"
  name "Iosevka SS04"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "iosevka-ss04-bold.ttc"
  font "iosevka-ss04-extrabold.ttc"
  font "iosevka-ss04-extralight.ttc"
  font "iosevka-ss04-heavy.ttc"
  font "iosevka-ss04-light.ttc"
  font "iosevka-ss04-medium.ttc"
  font "iosevka-ss04-regular.ttc"
  font "iosevka-ss04-semibold.ttc"
  font "iosevka-ss04-thin.ttc"

  # No zap stanza required
end