cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.4.1"
  sha256 arm:   "48e60faec2fef3a04eaf5309e07935bc101e5f78c4d328337c18e7513b63f3db",
         intel: "95ae8b71c7158fca392a9ec02287a9085be487a45a18e79d65a1c789e556f35d"

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