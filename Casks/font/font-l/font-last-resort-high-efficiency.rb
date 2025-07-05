cask "font-last-resort-high-efficiency" do
  version "16.000"
  sha256 "60c48abfc05e9f2ba33599c4dcba40105d1ece71d3761f0b26f75a38b5b17895"

  url "https://ghfast.top/https://github.com/unicode-org/last-resort-font/releases/download/#{version}/LastResortHE-Regular.ttf"
  name "Last Resort High-Efficiency"
  homepage "https://github.com/unicode-org/last-resort-font"

  no_autobump! because: :requires_manual_review

  font "LastResortHE-Regular.ttf"

  # No zap stanza required
end