cask "font-pretendard-gov" do
  version "1.3.9"
  sha256 "080266d2faa8911b0e239b367405fdbcb2b4e17b22067e40aeb34a6c3fca0ac4"

  url "https:github.comorioncactuspretendardreleasesdownloadv#{version}PretendardGOV-#{version}.zip"
  name "Pretendard GOV"
  homepage "https:github.comorioncactuspretendard"

  font "publicstaticPretendardGOV-Black.otf"
  font "publicstaticPretendardGOV-Bold.otf"
  font "publicstaticPretendardGOV-ExtraBold.otf"
  font "publicstaticPretendardGOV-ExtraLight.otf"
  font "publicstaticPretendardGOV-Light.otf"
  font "publicstaticPretendardGOV-Medium.otf"
  font "publicstaticPretendardGOV-Regular.otf"
  font "publicstaticPretendardGOV-SemiBold.otf"
  font "publicstaticPretendardGOV-Thin.otf"

  # No zap stanza required
end