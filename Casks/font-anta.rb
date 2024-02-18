cask "font-anta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflantaAnta-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Anta"
  desc "Particularly suitable for graphic design, but also for branding projects"
  homepage "https:fonts.google.comspecimenAnta"

  font "Anta-Regular.ttf"

  # No zap stanza required
end