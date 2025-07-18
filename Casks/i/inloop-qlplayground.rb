cask "inloop-qlplayground" do
  version "1.0"
  sha256 "44c25a7da0dc3748b01deb0c01634044ccbc625b4266b4fea0630cbedb773929"

  url "https://ghfast.top/https://github.com/inloop/qlplayground/releases/download/v#{version}/inloop-qlplayground.v#{version}.zip"
  name "INLOOPX QLPlayground"
  desc "Quick Look generator for Xcode Playgrounds"
  homepage "https://github.com/inloop/qlplayground"

  no_autobump! because: :requires_manual_review

  qlplugin "inloop-qlplayground.qlgenerator"

  # No zap stanza required
end