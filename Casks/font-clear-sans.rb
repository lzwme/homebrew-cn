cask "font-clear-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comintelclear-sans.git",
      branch:    "main",
      only_path: "TTF"
  name "Clear Sans"
  desc "Sans-serif typeface"
  homepage "https:github.comintelclear-sans"

  font "ClearSans-Bold.ttf"
  font "ClearSans-BoldItalic.ttf"
  font "ClearSans-Italic.ttf"
  font "ClearSans-Light.ttf"
  font "ClearSans-Medium.ttf"
  font "ClearSans-MediumItalic.ttf"
  font "ClearSans-Regular.ttf"
  font "ClearSans-Thin.ttf"

  # No zap stanza required

  caveats do
    discontinued
  end
end