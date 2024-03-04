cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.2.0"
  sha256 arm:   "f62cc0e31549992127da3fa1bb68504729c8cc87217ee3871747f9287ee6aaee",
         intel: "53831654cb679e2d1e4085a32d53e0d93e201c1a2d911c276f54715b5afcc724"

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