cask "livebook" do
  version "0.11.0"
  sha256 "9a7cf81873a0b01f652102a12645d1c4812dd7627ab5f0a4957d130d8d995ba0"

  url "https://ghproxy.com/https://github.com/livebook-dev/livebook/releases/download/v#{version}/LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.com/livebook-dev/livebook/"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https://livebook.dev/"

  app "Livebook.app"

  zap trash: "~/Library/Application Support/livebook"
end