cask "openthesaurus-deutsch" do
  version "2024.05.14"
  sha256 "1fb1e2ae141e646c5caf56cb139383209344cdeca653cb4aac138fcfc4e06388"

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