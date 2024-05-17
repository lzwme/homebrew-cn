cask "font-material-icons" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglematerial-design-icons.git",
      verified:  "github.comgooglematerial-design-icons",
      branch:    "master",
      only_path: "font"
  name "Material Icons"
  desc "Icons based on core Material Design principles"
  homepage "https:google.github.iomaterial-design-icons"

  font "MaterialIcons-Regular.ttf"
  font "MaterialIconsOutlined-Regular.otf"
  font "MaterialIconsSharp-Regular.otf"
  font "MaterialIconsTwoTone-Regular.otf"

  # No zap stanza required
end