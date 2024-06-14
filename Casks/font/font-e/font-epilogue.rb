cask "font-epilogue" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflepilogue"
  name "Epilogue"
  homepage "https:fonts.google.comspecimenEpilogue"

  font "Epilogue-Italic[wght].ttf"
  font "Epilogue[wght].ttf"

  # No zap stanza required
end