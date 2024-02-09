cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.0.0"
  sha256 arm:   "6c18db6122d6f0f03113bdf6a5964ed6af3e9dad54578b11248c4a25405ff1e8",
         intel: "1324d7472710d85d0a930d0cea7930269c54d1332acedef3dd2f466f40da8aa7"

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