cask "openthesaurus-deutsch" do
  version "2025.01.21"
  sha256 "4a7acba0232602f48f266dcff1e00caafc9ec6f150fc2ef5d3e67565d5d9da7c"

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