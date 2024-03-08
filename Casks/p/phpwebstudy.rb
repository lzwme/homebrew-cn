cask "phpwebstudy" do
  arch arm: "-arm64"

  version "2.2.5"
  sha256 arm:   "fc20f7652e3c4b672097034612014d25cc74d53be568077eb978a3fff8abf763",
         intel: "a560789620207b190c968bd92b0b5b7d3794aa1a992033817e9fbfd8993dfaea"

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