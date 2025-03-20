cask "pdl" do
  version "0.5.0"
  sha256 "6ab7441bda872307b173cce567c169d4ad11b198d11f8490e76e1bb27784ac4d"

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