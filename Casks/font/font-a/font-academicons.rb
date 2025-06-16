cask "font-academicons" do
  version "1.9.4"
  sha256 "5b6aeecaaf2a63d23b07b722f3e1be2ae1a12f433677704e73a6b8f564943784"

  url "https:github.comjpswalshacademiconsarchiverefstagsv#{version}.tar.gz"
  name "Academicons"
  homepage "https:github.comjpswalshacademicons"

  no_autobump! because: :requires_manual_review

  font "academicons-#{version}fontsacademicons.ttf"

  # No zap stanza required
end