cask "continuity-activation-tool" do
  version "1.0"
  sha256 :no_check

  url "https:github.comdokterdokContinuity-Activation-Toolarchiverefsheadsmaster.tar.gz"
  name "Continuity Activation Tool"
  desc "Enable continuity features on compatible hardware"
  homepage "https:github.comdokterdokContinuity-Activation-Tool"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-06", because: :unmaintained

  app "Continuity-Activation-Tool-masterContinuity Activation Tool.app"
end