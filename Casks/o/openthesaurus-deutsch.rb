cask "openthesaurus-deutsch" do
  version "2024.07.15"
  sha256 "8f1d137614fca7ff9b07b60913234202d1d69718526b57b860b32dfdc3307ab7"

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