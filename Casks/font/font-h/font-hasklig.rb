cask "font-hasklig" do
  version "1.2"
  sha256 "9cd35a7449b220dc84f9516c57817e147003fc905a477f1ec727816d9d8a81d4"

  url "https:github.comi-tuHaskligreleasesdownloadv#{version}Hasklig-#{version}.zip"
  name "Hasklig"
  homepage "https:github.comi-tuHasklig"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "OTFHasklig-Black.otf"
  font "OTFHasklig-BlackIt.otf"
  font "OTFHasklig-Bold.otf"
  font "OTFHasklig-BoldIt.otf"
  font "OTFHasklig-ExtraLight.otf"
  font "OTFHasklig-ExtraLightIt.otf"
  font "OTFHasklig-It.otf"
  font "OTFHasklig-Light.otf"
  font "OTFHasklig-LightIt.otf"
  font "OTFHasklig-Medium.otf"
  font "OTFHasklig-MediumIt.otf"
  font "OTFHasklig-Regular.otf"
  font "OTFHasklig-Semibold.otf"
  font "OTFHasklig-SemiboldIt.otf"

  # No zap stanza required
end