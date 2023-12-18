cask "font-pretendard" do
  version "1.3.9"
  sha256 "04be351a74d6bf7d60c480a3087e51d185485d35a52023142af1df19eb8c428a"

  url "https:github.comorioncactuspretendardreleasesdownloadv#{version}Pretendard-#{version}.zip"
  name "Pretendard"
  desc "Alternative font to system-ui for all platforms"
  homepage "https:github.comorioncactuspretendard"

  font "publicstaticPretendard-Black.otf"
  font "publicstaticPretendard-Bold.otf"
  font "publicstaticPretendard-ExtraBold.otf"
  font "publicstaticPretendard-ExtraLight.otf"
  font "publicstaticPretendard-Light.otf"
  font "publicstaticPretendard-Medium.otf"
  font "publicstaticPretendard-Regular.otf"
  font "publicstaticPretendard-SemiBold.otf"
  font "publicstaticPretendard-Thin.otf"

  # No zap stanza required
end