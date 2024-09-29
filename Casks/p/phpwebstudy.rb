cask "phpwebstudy" do
  arch arm: "-arm64"

  version "4.3.5"
  sha256 arm:   "87556d4f58b02fd58edf8784e0cda7c2013950ef315124c6c6a7aa8db98990cb",
         intel: "01b1ba325b03cfd6825126dfffd7ce4c5081f42e507da9fa16e6398307832f27"

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