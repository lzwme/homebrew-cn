cask "pdl" do
  version "0.4.2"
  sha256 "82c59369a25c9ea8d4422f22b00d10e1d7191a52c4caed5c35d1c4919e50b5b8"

  url "https:github.comIBMprompt-declaration-languagereleasesdownloadv#{version}PDL_#{version}_universal.dmg",
      verified: "github.comIBMprompt-declaration-language"
  name "PDL"
  desc "Declarative language for creating reliable, composable LLM prompts"
  homepage "https:ibm.github.ioprompt-declaration-language"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "PDL.app"
  binary "#{appdir}PDL.appContentsMacOSPDL", target: "pdl"

  zap trash: "~LibraryApplication SupportPDL"
end