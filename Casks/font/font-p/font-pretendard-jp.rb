cask "font-pretendard-jp" do
  version "1.3.9"
  sha256 "8dab678c371a1530106ca643b76b2b80d47653d5ba670b01265b48e4c6615d63"

  url "https:github.comorioncactuspretendardreleasesdownloadv#{version}PretendardJP-#{version}.zip"
  name "Pretendard JP"
  desc "Alternative font to system-ui for all platforms"
  homepage "https:github.comorioncactuspretendard"

  font "publicstaticPretendardJP-Black.otf"
  font "publicstaticPretendardJP-Bold.otf"
  font "publicstaticPretendardJP-ExtraBold.otf"
  font "publicstaticPretendardJP-ExtraLight.otf"
  font "publicstaticPretendardJP-Light.otf"
  font "publicstaticPretendardJP-Medium.otf"
  font "publicstaticPretendardJP-Regular.otf"
  font "publicstaticPretendardJP-SemiBold.otf"
  font "publicstaticPretendardJP-Thin.otf"

  # No zap stanza required
end