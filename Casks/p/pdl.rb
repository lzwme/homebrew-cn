cask "pdl" do
  version "0.3.0"
  sha256 "4d3797e3bad93dc035d413ee6e1add34d9eab0fc0b83defe23eb38f9e75d30af"

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