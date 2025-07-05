cask "spechtlite" do
  version "0.10.7"
  sha256 "244e6daa406fa4e45451d0f08688d91770d25cb559485a76788568f47bac7101"

  url "https://ghfast.top/https://github.com/zhuhaow/SpechtLite/releases/download/#{version}/SpechtLite.zip"
  name "SpechtLite"
  desc "Rule-based proxy"
  homepage "https://github.com/zhuhaow/SpechtLite"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "SpechtLite.app"
end