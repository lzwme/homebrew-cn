cask "font-iosevka-slab" do
  version "32.0.0"
  sha256 "972e384ad2b45530f3058e160ceba21644910154395062436ca8e464913c851f"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSlab-#{version}.zip"
  name "Iosevka Slab"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSlab.ttc"

  # No zap stanza required
end