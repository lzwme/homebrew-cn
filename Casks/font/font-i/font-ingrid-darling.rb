cask "font-ingrid-darling" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflingriddarlingIngridDarling-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ingrid Darling"
  homepage "https:fonts.google.comspecimenIngrid+Darling"

  font "IngridDarling-Regular.ttf"

  # No zap stanza required
end