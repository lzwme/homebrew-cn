cask "font-stardos-stencil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflstardosstencil"
  name "Stardos Stencil"
  homepage "https:fonts.google.comspecimenStardos+Stencil"

  font "StardosStencil-Bold.ttf"
  font "StardosStencil-Regular.ttf"

  # No zap stanza required
end