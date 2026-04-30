cask "koharu" do
  version "0.55.0"
  sha256 "c35cf3cb5c56e226d1746a6e8a76d9472c86d2b16d0ad0633c474ad225bdea92"

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