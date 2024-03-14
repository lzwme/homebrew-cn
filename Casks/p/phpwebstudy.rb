cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.3.2"
  sha256 arm:   "b088daed23edbf098e54a0792e741c8ecd15ec64b2b8421027e497f17840747b",
         intel: "c12e37fa298bb0da05c3bec420f7844baf12a1122d996fd408cdc56fe0e470be"

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