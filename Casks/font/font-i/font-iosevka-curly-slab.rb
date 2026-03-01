cask "font-iosevka-curly-slab" do
  version "34.2.0"
  sha256 "a6407e7222ccd73410a922378e012f371f6b0e34aefbed2a1ae1f375c8519b91"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaCurlySlab-#{version}.zip"
  name "Iosevka Curly Slab"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurlySlab.ttc"

  # No zap stanza required
end