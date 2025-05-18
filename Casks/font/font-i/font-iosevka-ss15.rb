cask "font-iosevka-ss15" do
  version "33.2.3"
  sha256 "324fc22d1c27840b33a1313fb60fe6288a3cdef3b1b279b19cdd7d6fa5bbc18a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS15-#{version}.zip"
  name "Iosevka SS15"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS15.ttc"

  # No zap stanza required
end