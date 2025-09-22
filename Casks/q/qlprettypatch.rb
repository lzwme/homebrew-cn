cask "qlprettypatch" do
  version "1.0"
  sha256 "ae2cb623cc741bf053fdfad0b5f1435c3bbad6d4b3f37d43b407296c46462182"

  url "https://ghfast.top/https://github.com/atnan/QLPrettyPatch/releases/download/v#{version}/QLPrettyPatch.qlgenerator.zip"
  name "QLPrettyPatch"
  desc "Quick Look plugin to view patch files"
  homepage "https://github.com/atnan/QLPrettyPatch"

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "QLPrettyPatch.qlgenerator"

  # No zap stanza required
end