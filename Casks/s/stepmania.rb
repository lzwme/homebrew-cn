cask "stepmania" do
  version "5.0.12"
  sha256 "b49eb7f4405c8cc289053deb48c30edcd8517a2948853e77befe9073818eb336"

  url "https:github.comstepmaniastepmaniareleasesdownloadv#{version}StepMania-#{version}-mac.dmg",
      verified: "github.comstepmaniastepmania"
  name "StepMania"
  desc "Advanced rhythm game designed for both home and arcade use"
  homepage "https:www.stepmania.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "StepMania-#{version}Stepmania.app"
end