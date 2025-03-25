cask "openthesaurus-deutsch" do
  version "2025.03.24"
  sha256 "095ff0ade92893980151ef627486f6295949cbfc982784027d860fbc9054fab0"

  url "https:github.comTeklopenthesaurus-deutschreleasesdownloadv#{version}OpenThesaurus_Deutsch_dictionaryfile.zip",
      verified: "github.comTeklopenthesaurus-deutsch"
  name "OpenThesaurus Deutsch Dictionary plugin"
  desc "German thesaurus for Apple Dictionary"
  homepage "https:tekl.delexikon-plug-insopenthesaurus-deutsch-lexikon-plugin"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :el_capitan"

  dictionary "OpenThesaurus Deutsch.dictionary"

  # No zap stanza required
end