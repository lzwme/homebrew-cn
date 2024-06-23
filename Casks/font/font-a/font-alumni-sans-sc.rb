cask "font-alumni-sans-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflalumnisanssc"
  name "Alumni Sans SC"
  homepage "https:github.comgooglefontsalumni"

  font "AlumniSansSC-Italic[wght].ttf"
  font "AlumniSansSC[wght].ttf"

  # No zap stanza required
end