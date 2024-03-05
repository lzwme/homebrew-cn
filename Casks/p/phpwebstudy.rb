cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.2.1"
  sha256 arm:   "cdb6de089d3a0db983de35652d23fd0a8b81a0410178fcb34f48c3e4cb6a247a",
         intel: "dc2040d8dcec5eb66644c6bb00c0014dee0f97af7692657ab24a0047f18b9f02"

  url "https:github.comxpf0000PhpWebStudyreleasesdownloadv#{version}PhpWebStudy-#{version}#{arch}-mac.zip",
      verified: "github.comxpf0000PhpWebStudy"
  name "PhpWebStudy"
  desc "PHP and Web development environment manager"
  homepage "https:www.macphpstudy.com"

  livecheck do
    url "https:raw.githubusercontent.comxpf0000PhpWebStudymasterlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true

  app "PhpWebStudy.app"

  zap trash: [
    "~LibraryApplication SupportPhpWebStudy",
    "~LibraryLogsPhpWebStudy",
    "~LibraryPhpWebStudy",
  ]
end