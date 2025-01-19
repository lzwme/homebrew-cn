cask "font-iosevka-ss08" do
  version "32.4.0"
  sha256 "384dcd7fe2cb1d945e1476a69580416851acb8358e0d72c417bb68eb9ba1575a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end