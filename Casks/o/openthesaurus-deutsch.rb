cask "openthesaurus-deutsch" do
  version "2023.12.28"
  sha256 "cb12ab497c71d0aa56cfa6ae2df4b5e5b9fb7eed424c35dd82400cc9ce66a9e5"

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