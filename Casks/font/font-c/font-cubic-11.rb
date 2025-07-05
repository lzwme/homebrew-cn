cask "font-cubic-11" do
  version "1.430"
  sha256 "d4b71e5666cc6eef27a6e1b94db1378f4c5698f76711b508129dfbb8f8d1a61b"

  url "https://ghfast.top/https://github.com/ACh-K/Cubic-11/archive/refs/tags/v#{version}.tar.gz"
  name "Cubic 11"
  name "俐方體11號"
  homepage "https://github.com/ACh-K/Cubic-11"

  no_autobump! because: :requires_manual_review

  font "Cubic-11-#{version}/fonts/ttf/Cubic_11.ttf"

  # No zap stanza required
end