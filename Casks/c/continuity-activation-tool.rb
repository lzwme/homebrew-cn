cask "continuity-activation-tool" do
  version "1.0"
  sha256 :no_check

  url "https:github.comdokterdokContinuity-Activation-Toolarchiverefsheadsmaster.tar.gz"
  name "Continuity Activation Tool"
  desc "Enable continuity features on compatible hardware"
  homepage "https:github.comdokterdokContinuity-Activation-Tool"

  livecheck do
    url :url
    strategy :extract_plist do |items|
      items["org.dokterdok.ContinuityActivationTool"].short_version
    end
  end

  app "Continuity-Activation-Tool-masterContinuity Activation Tool.app"
end