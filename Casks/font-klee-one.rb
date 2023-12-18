cask "font-klee-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkleeone"
  name "Klee One"
  homepage "https:fonts.google.comspecimenKlee+One"

  font "KleeOne-Regular.ttf"
  font "KleeOne-SemiBold.ttf"

  # No zap stanza required
end