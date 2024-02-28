cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.1.1"
  sha256 arm:   "aceb1a854e7b81f8f21b8d1cadbfb3af2a1ac7740e7769d449ad3a33dcf45fca",
         intel: "bdaabce2e3d4a38e464ff819d8da2ee303a02ce50b5727e3c272a860261f05dc"

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