cask "lando@edge" do
  arch arm: "arm64", intel: "x64"

  version "3.20.8"
  sha256 arm:   "111a4994b1b7badc8cb91a4a29f1f7064bc1e29ef0f225e3d040b72fbb6c0037",
         intel: "43503628455d34da6e429cc7c88cc49acca14311a6756270241a96528061c528"

  url "https://ghfast.top/https://github.com/lando/lando/releases/download/v#{version}/lando-#{arch}-v#{version}.dmg",
      verified: "github.com/lando/lando/"
  name "Lando Edge"
  desc "Local development environment and DevOps tool built on Docker"
  homepage "https://docs.lando.dev/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-07", because: "no longer distributes an install package"

  conflicts_with cask: "lando"
  depends_on cask: "docker"

  pkg "LandoInstaller.pkg",
      choices: [
        {
          "choiceIdentifier" => "choiceDocker",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
        {
          "choiceIdentifier" => "choiceLando",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 1,
        },
      ]

  uninstall pkgutil: "dev.lando.pkg.lando"

  zap trash: "~/.lando"
end