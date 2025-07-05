cask "font-kawkab-mono" do
  version "0.501"
  sha256 "11c06f57dddefaf0166d74caaa072865ab6ff8d34076e7ec5d2c20edda145666"

  url "https://ghfast.top/https://github.com/aiaf/kawkab-mono/releases/download/v#{version}/kawkab-mono-#{version}.zip",
      verified: "github.com/aiaf/kawkab-mono/"
  name "Kawkab Mono"
  homepage "https://makkuk.com/kawkab-mono"

  no_autobump! because: :requires_manual_review

  font "kawkab-mono-#{version}/KawkabMono-Bold.otf"
  font "kawkab-mono-#{version}/KawkabMono-Light.otf"
  font "kawkab-mono-#{version}/KawkabMono-Regular.otf"

  # No zap stanza required
end