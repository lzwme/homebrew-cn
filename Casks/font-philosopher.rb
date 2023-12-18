cask "font-philosopher" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflphilosopher"
  name "Philosopher"
  homepage "https:fonts.google.comspecimenPhilosopher"

  font "Philosopher-Bold.ttf"
  font "Philosopher-BoldItalic.ttf"
  font "Philosopher-Italic.ttf"
  font "Philosopher-Regular.ttf"

  # No zap stanza required
end