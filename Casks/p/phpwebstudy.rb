cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.2.4"
  sha256 arm:   "f8de3f841de9d154df42af05bb585df43f2a3461afbeccf9cc107ffd64c94b21",
         intel: "2941aa3934efee6f4608e9aa2a5dbe8f8aa4eff2b4fddf30019722c7e9bb5ad1"

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