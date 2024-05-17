cask "font-rubik-maze" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikmazeRubikMaze-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Maze"
  homepage "https:fonts.google.comspecimenRubik+Maze"

  font "RubikMaze-Regular.ttf"

  # No zap stanza required
end