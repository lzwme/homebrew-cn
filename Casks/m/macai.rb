cask "macai" do
  version "2.0.9"
  sha256 "e09233c49e6fb2cd3eb93df50f22bafec20d3e6b81473126b4365905203a519d"

  url "https:github.comRensetmacaireleasesdownloadv#{version}macai.#{version}.Universal.zip"
  name "macai"
  desc "Native chat application for all major LLM APIs"
  homepage "https:github.comRensetmacai"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "macai.app"

  zap trash: [
    "~LibraryApplication Scriptsnotfullin.com.macai",
    "~LibraryContainersnotfullin.com.macai",
  ]
end