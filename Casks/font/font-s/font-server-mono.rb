cask "font-server-mono" do
  version "0.0.5"
  sha256 "ba94c13607a98a8bf303e785c5cdf03d90d77089469c68ccbb4f4f4564f21719"

  url "https:github.cominternet-developmentwww-server-monoarchiverefstags#{version}.tar.gz",
      verified: "github.cominternet-developmentwww-server-mono"
  name "Server Mono"
  homepage "https:servermono.com"

  font "www-server-mono-#{version}fontsServerMono-Regular.otf"
  font "www-server-mono-#{version}fontsServerMono-Regular-Italic.otf"

  # No zap stanza required
end