cask "font-pt-sans-caption" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflptsanscaption"
  name "PT Sans Caption"
  homepage "https:fonts.google.comspecimenPT+Sans+Caption"

  font "PT_Sans-Caption-Web-Bold.ttf"
  font "PT_Sans-Caption-Web-Regular.ttf"

  # No zap stanza required
end