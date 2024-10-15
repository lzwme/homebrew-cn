cask "font-iosevka-curly-slab" do
  version "31.9.1"
  sha256 "948ff6ccf75834e8630b4a827fb75320b9b0cca6978adb4a99b0d96ea49dacb0"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurlySlab-#{version}.zip"
  name "Iosevka Curly Slab"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurlySlab.ttc"

  # No zap stanza required
end