cask "macai" do
  version "2.0.8"
  sha256 "d04bfa3e289c2e646e3c40943055ed5d3dc863fb39cd3b313106b885603dab2e"

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