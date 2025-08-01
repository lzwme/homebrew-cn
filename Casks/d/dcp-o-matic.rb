cask "dcp-o-matic" do
  version "2.18.21"
  sha256 "2fb593b6dbd47fec63f7df6eef65c03eed7a495b1ed15156d58026297d3a3f03"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-main&version=#{version}"
  name "DCP-o-matic"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  disable! date: "2025-07-28", because: "cannot be reliably fetched due to Cloudflare protections"

  app "DCP-o-matic #{version.major}.app"

  # No zap stanza required
end