cask "font-redacted-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflredactedscript"
  name "Redacted Script"
  homepage "https:fonts.google.comspecimenRedacted+Script"

  font "RedactedScript-Bold.ttf"
  font "RedactedScript-Light.ttf"
  font "RedactedScript-Regular.ttf"

  # No zap stanza required
end