cask "pdl" do
  version "0.5.1"
  sha256 "2f4df261801454c704b31a041c2a22693f70d2377e750bc80bce050f3078c36e"

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