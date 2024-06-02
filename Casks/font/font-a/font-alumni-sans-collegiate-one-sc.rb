cask "font-alumni-sans-collegiate-one-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflalumnisanscollegiateonesc"
  name "Alumni Sans Collegiate One SC"
  desc "The small caps version of alumni sans collegiate one to contribute, see github"
  homepage "https:github.comgooglefontsalumni-sans-collegiate"

  font "AlumniSansCollegiateOneSC-Italic.ttf"
  font "AlumniSansCollegiateOneSC-Regular.ttf"

  # No zap stanza required
end