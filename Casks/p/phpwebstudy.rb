cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.3.0"
  sha256 arm:   "bf96e1db861549ee2b190977ec552a7d67dc1421b87a68a95b4d542ae4680ae1",
         intel: "1bf686c551d115604950e04da60f45c95da79fdd8aec21c82bd4a3ee8afb559a"

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