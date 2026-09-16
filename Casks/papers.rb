cask "papers" do
  version "0.4.6"
  sha256 "ce5cdc32cdf2b36f76eaf7a5173848f952432daa257b117814a1768ffaf9b7ea"

  url "https://ghfast.top/https://github.com/bandundu/papers-releases/releases/download/v#{version}/Papers-#{version}-arm64.dmg"
  name "Papers"
  desc "Native client for Paperless-ngx"
  homepage "https://www.papersapp.info/"

  livecheck do
    url :stable
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :monterey

  app "Papers.app"
end