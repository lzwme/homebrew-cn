cask "font-finger-paint" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfingerpaintFingerPaint-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Finger Paint"
  homepage "https:fonts.google.comspecimenFinger+Paint"

  font "FingerPaint-Regular.ttf"

  # No zap stanza required
end