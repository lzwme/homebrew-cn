cask "macai" do
  version "2.0.11"
  sha256 "54e61bb5bd3cbf9bfbd095809d54027169ad916be66f9fae21b03a7274f1af07"

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