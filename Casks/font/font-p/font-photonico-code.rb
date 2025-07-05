cask "font-photonico-code" do
  version "1.5"
  sha256 "7d553f8f28a8a35b5a1a820bdcd68b42a6f1b54c820a25c76ec9e41e2bc807c1"

  url "https://ghfast.top/https://github.com/Photonico/Photonico_Code/releases/download/#{version}/Photonico.#{version}.Regular.ttf"
  name "Photonico Code"
  homepage "https://github.com/Photonico/Photonico_Code"

  no_autobump! because: :requires_manual_review

  font "Photonico.#{version}.Regular.ttf"

  # No zap stanza required
end