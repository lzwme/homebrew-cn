cask "phpwebstudy" do
  arch arm: "-arm64"

  version "4.4.0"
  sha256 arm:   "a266ad4a74f0d41cf8755ff85012ba968c19ef2b59d3ed479b8503ecef1e267a",
         intel: "7ccc7a4ecb883c2e637ac893e16d92bbb4303a0004935dc792d5e0ba1e45a914"

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