cask "ace-link" do
  version "2.1.0"
  sha256 "778e122a739c53aba5e5a8715b630b287089ef89870064a0345c0ee526d44886"

  url "https://ghfast.top/https://github.com/blaise-io/acelink/releases/download/#{version}/Ace.Link.#{version}.dmg"
  name "Ace Link"
  desc "Menu bar app for playing Ace Stream video streams in an external media player"
  homepage "https://github.com/blaise-io/acelink"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "docker"

  app "Ace Link.app"

  uninstall quit: "blaise.io.acelink"

  zap trash: "~/Library/Application Support/Ace Link"
end