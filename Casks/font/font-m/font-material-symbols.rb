cask "font-material-symbols" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglematerial-design-icons.git",
      verified:  "github.comgooglematerial-design-icons",
      branch:    "master",
      only_path: "variablefont"
  name "Material Symbols"
  homepage "https:fonts.google.comicons"

  font "MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"
  font "MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
  font "MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf"

  # No zap stanza required
end