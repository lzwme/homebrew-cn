cask "font-gidole" do
  version :latest
  sha256 :no_check

  url "https:github.comgidoleGidole-Typefacesrawmastergidole.zip",
      verified: "github.comgidole"
  name "Gidole"
  homepage "https:gidole.github.io"

  font "GidoleFontGidole-Regular.ttf"
  font "GidoleFontGidolinya-Regular.otf"

  # No zap stanza required
end