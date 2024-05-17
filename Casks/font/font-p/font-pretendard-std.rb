cask "font-pretendard-std" do
  version "1.3.9"
  sha256 "bde2ecb6aa27fb1d36b729b47b1cad5a890dca8e8a06aebe0727b4c27624ad42"

  url "https:github.comorioncactuspretendardreleasesdownloadv#{version}PretendardStd-#{version}.zip"
  name "Pretendard Std"
  desc "Alternative font to system-ui for all platforms"
  homepage "https:github.comorioncactuspretendard"

  font "publicstaticPretendardStd-Black.otf"
  font "publicstaticPretendardStd-Bold.otf"
  font "publicstaticPretendardStd-ExtraBold.otf"
  font "publicstaticPretendardStd-ExtraLight.otf"
  font "publicstaticPretendardStd-Light.otf"
  font "publicstaticPretendardStd-Medium.otf"
  font "publicstaticPretendardStd-Regular.otf"
  font "publicstaticPretendardStd-SemiBold.otf"
  font "publicstaticPretendardStd-Thin.otf"

  # No zap stanza required
end