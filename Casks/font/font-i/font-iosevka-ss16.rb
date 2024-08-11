cask "font-iosevka-ss16" do
  version "31.2.0"
  sha256 "af60d2df123c39ef35a65c0d12f00a344f36300642b2aba7cb62759a2105627f"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end