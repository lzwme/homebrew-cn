cask "macai" do
  version "2.0.2"
  sha256 "53c18fd2806d35c7896e77f49199c59e7238ff7281ef43899985b0e6f4e361c4"

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