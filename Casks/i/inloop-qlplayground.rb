cask "inloop-qlplayground" do
  version "1.0"
  sha256 "44c25a7da0dc3748b01deb0c01634044ccbc625b4266b4fea0630cbedb773929"

  url "https://ghfast.top/https://github.com/inloop/qlplayground/releases/download/v#{version}/inloop-qlplayground.v#{version}.zip"
  name "INLOOPX QLPlayground"
  desc "Quick Look generator for Xcode Playgrounds"
  homepage "https://github.com/inloop/qlplayground"

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "inloop-qlplayground.qlgenerator"

  # No zap stanza required
end