cask "phpwebstudy" do
  arch arm: "-arm64"

  version "1.7.1"
  sha256 arm:   "f9109cadb6681a63fd7aaa5f901754fbdc0c825b85cd917e3cafa01d99b6bebf",
         intel: "d3578c4718884e2fb568871a5b175a7736c846283b8c5593359f122a141be66a"

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