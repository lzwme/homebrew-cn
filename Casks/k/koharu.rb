cask "koharu" do
  version "0.54.0"
  sha256 "2cde7ab007eefd284475512b5153f27d813dfb0e23ca949f8e937314465307a2"

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