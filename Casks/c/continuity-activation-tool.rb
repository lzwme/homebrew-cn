cask "continuity-activation-tool" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/dokterdok/Continuity-Activation-Tool/archive/refs/heads/master.tar.gz"
  name "Continuity Activation Tool"
  desc "Enable continuity features on compatible hardware"
  homepage "https://github.com/dokterdok/Continuity-Activation-Tool/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-06", because: :unmaintained
  disable! date: "2025-07-06", because: :unmaintained

  app "Continuity-Activation-Tool-master/Continuity Activation Tool.app"
end