cask "font-kawkab-mono" do
  version "0.501"
  sha256 "11c06f57dddefaf0166d74caaa072865ab6ff8d34076e7ec5d2c20edda145666"

  url "https:github.comaiafkawkab-monoreleasesdownloadv#{version}kawkab-mono-#{version}.zip",
      verified: "github.comaiafkawkab-mono"
  name "Kawkab Mono"
  homepage "https:makkuk.comkawkab-mono"

  no_autobump! because: :requires_manual_review

  font "kawkab-mono-#{version}KawkabMono-Bold.otf"
  font "kawkab-mono-#{version}KawkabMono-Light.otf"
  font "kawkab-mono-#{version}KawkabMono-Regular.otf"

  # No zap stanza required
end