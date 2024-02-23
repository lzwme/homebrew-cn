cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.0.1"
  sha256 arm:   "f89be1159d2a1a8017df56bde58a42ef8e637cb96c522b60eaa8335191278bd7",
         intel: "a80da58693a30e8d6027c1290aa2b9913034c431069ef6a61a76372395f9699a"

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