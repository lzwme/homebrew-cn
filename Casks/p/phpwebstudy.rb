cask "phpwebstudy" do
  arch arm: "-arm64"

  version "4.3.0"
  sha256 arm:   "a98c3edee6d518d6a5b07240cd6ea3f2e12d08519e25c4f8205c2ce5c2b9e1f5",
         intel: "c101e9b564f451f4811430c42ea1a04174a055677ee4da9043b0e7bc6faf4fc0"

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