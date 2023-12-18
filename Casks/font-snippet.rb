cask "font-snippet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsnippetSnippet.ttf",
      verified: "github.comgooglefonts"
  name "Snippet"
  homepage "https:fonts.google.comspecimenSnippet"

  font "Snippet.ttf"

  # No zap stanza required
end