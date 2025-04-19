cask "pdl" do
  version "0.6.1"
  sha256 "4b3b121d2d904c23f6657dcfd2e9bb0cf2fc0e1330eeffae7001a72bf1cf5b91"

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