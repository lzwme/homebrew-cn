cask "phpwebstudy" do
  arch arm: "-arm64"

  version "1.3.0"
  sha256 arm:   "e62ec3b8096ecc9f535d351f42071036144deb047b361c88163511de772db8f7",
         intel: "e374a94b30a16dc288978967fbed951d89092b96cb6982684913cd2680b90fa7"

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