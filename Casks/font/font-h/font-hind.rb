cask "font-hind" do
  version "2.000"
  sha256 "8748ce1fa0db67d0c782d7824a9fdcf0b8544b9d063db477dff9733774571193"

  url "https:github.comitfoundryhindreleasesdownloadv2.000hind-#{version.dots_to_underscores}.zip"
  name "Hind"
  homepage "https:github.comitfoundryhind"

  font "Hind-Bold.otf"
  font "Hind-Light.otf"
  font "Hind-Medium.otf"
  font "Hind-Regular.otf"
  font "Hind-SemiBold.otf"

  # No zap stanza required
end