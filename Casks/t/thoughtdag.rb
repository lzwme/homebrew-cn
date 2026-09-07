cask "thoughtdag" do
  arch arm: "-arm64"

  version "0.4.6"
  sha256 arm:   "080347c113e1a550ef4d59c8c01cc24f2954945124658bcdb633932eb2157c90",
         intel: "bb57ba1a9f08ab555d651c550b3b2d8b0322f800d2ac2da4901dc4d74e0cf0e1"

  url "https://ghfast.top/https://github.com/chenxiachan/thoughtdag/releases/download/v#{version}/ThoughtDAG-#{version}#{arch}.dmg"
  name "ThoughtDAG"
  desc "Visual workspace for editable LLM context graphs"
  homepage "https://chenxiachan.github.io/thoughtdag/"

  auto_updates true
  depends_on macos: :monterey

  app "ThoughtDAG.app"

  uninstall quit: "io.github.chenxiachan.thoughtdag"

  zap trash: [
    "~/Library/Application Support/thoughtdag-desktop",
    "~/Library/Caches/io.github.chenxiachan.thoughtdag",
    "~/Library/HTTPStorages/io.github.chenxiachan.thoughtdag",
    "~/Library/Logs/ThoughtDAG",
    "~/Library/Preferences/io.github.chenxiachan.thoughtdag.plist",
    "~/Library/Saved Application State/io.github.chenxiachan.thoughtdag.savedState",
  ]
end