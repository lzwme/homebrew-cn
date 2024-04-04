cask "jamie" do
  version "4.0.6"
  sha256 "bcc278e2f3e7a4505b3bcce84820356d670bf0d0b6012a0ad0d15cba66fb0373"

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