cask "font-overpass" do
  version "3.0.5"
  sha256 "beb7528f1e9adf3decf841f02510a3752820561a06842f9097d9f2565fe41f34"

  url "https:github.comRedHatOfficialOverpassarchiverefstagsv#{version}.tar.gz",
      verified: "github.comRedHatOfficialOverpass"
  name "Overpass"
  homepage "https:overpassfont.org"

  no_autobump! because: :requires_manual_review

  font "Overpass-#{version}desktop-fontsoverpassoverpass-bold-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-bold.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extrabold-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extrabold.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extralight-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-extralight.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-heavy-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-heavy.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-light-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-light.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-regular.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-semibold-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-semibold.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-thin-italic.otf"
  font "Overpass-#{version}desktop-fontsoverpassoverpass-thin.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-bold.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-light.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-regular.otf"
  font "Overpass-#{version}desktop-fontsoverpass-monooverpass-mono-semibold.otf"

  # No zap stanza required
end