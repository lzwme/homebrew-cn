cask "font-annapurna-sil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflannapurnasil"
  name "Annapurna SIL"
  desc "Unicode-based font with support for systems that use the devanagari script"
  homepage "https:fonts.google.comspecimenAnnapurna+SIL"

  font "AnnapurnaSIL-Bold.ttf"
  font "AnnapurnaSIL-Regular.ttf"

  # No zap stanza required
end