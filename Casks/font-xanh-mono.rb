cask "font-xanh-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflxanhmono"
  name "Xanh Mono"
  desc "Mono-serif typeface, designed by lam bao and duy dao"
  homepage "https:fonts.google.comspecimenXanh+Mono"

  font "XanhMono-Italic.ttf"
  font "XanhMono-Regular.ttf"

  # No zap stanza required
end