cask "phpwebstudy" do
  arch arm: "-arm64"

  version "4.0.0"
  sha256 arm:   "b8cf9dd4e50b258470577f5db5b407ace3be8e7561e29e7fb75812e784f4bd0a",
         intel: "8cd2fa0a80b86c5c0d0e641c5c43143d55e4e3f8618a3b806f18da44a8224356"

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