cask "jamie" do
  version "4.0.8"
  sha256 "aea56283c4ae2f37edcaabdb03d82aec751efbb3ed3f718da2eaab37fb3b68de"

  url "https:github.comlouismorgnerjamie-releasereleasesdownloadv#{version}jamie-#{version}.dmg",
      verified: "github.comlouismorgnerjamie-release"
  name "jamie"
  desc "AI-powered meeting notes"
  homepage "https:meetjamie.ai"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "jamie.app"

  zap trash: "~LibraryApplication Supportjamie"
end