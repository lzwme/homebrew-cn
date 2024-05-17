cask "font-major-mono-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmajormonodisplayMajorMonoDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Major Mono Display"
  homepage "https:fonts.google.comspecimenMajor+Mono+Display"

  font "MajorMonoDisplay-Regular.ttf"

  # No zap stanza required
end