cask "koharu" do
  version "0.58.0"
  sha256 "ce74a8514933b25027451fcec19185c8766f524f340b3ff7728b1731711b9a7c"

  url "https://ghfast.top/https://github.com/mayocream/koharu/releases/download/#{version}/koharu_#{version}_aarch64.dmg",
      verified: "github.com/mayocream/koharu/"
  name "Koharu"
  desc "ML-powered manga translator"
  homepage "https://koharu.rs/"

  depends_on :macos
  depends_on arch: :arm64

  app "Koharu.app"

  zap trash: [
    "~/Library/Application Support/Koharu",
    "~/Library/Caches/Koharu",
    "~/Library/WebKit/Koharu",
  ]
end