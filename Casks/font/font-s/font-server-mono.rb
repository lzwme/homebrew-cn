cask "font-server-mono" do
  version "0.0.4"
  sha256 "677169c9ed971ccafea0d55f4f34f3784e61a3b848784e12247608b344f477c4"

  url "https:github.cominternet-developmentwww-server-monoarchiverefstags#{version}.tar.gz",
      verified: "github.cominternet-developmentwww-server-mono"
  name "Server Mono"
  desc "Programming font designed for ASCII art and CLI tools"
  homepage "https:servermono.com"

  font "www-server-mono-#{version}fontsServerMono-Regular.otf"
  font "www-server-mono-#{version}fontsServerMono-Regular-Italic.otf"

  # No zap stanza required
end