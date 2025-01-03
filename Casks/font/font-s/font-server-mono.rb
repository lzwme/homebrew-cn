cask "font-server-mono" do
  version "0.0.6"
  sha256 "07d2eff6a11b9939b0d397198bec9258da6b43660d6f0fa8814e543f617d2b82"

  url "https:github.cominternet-developmentwww-server-monoarchiverefstags#{version}.tar.gz",
      verified: "github.cominternet-developmentwww-server-mono"
  name "Server Mono"
  homepage "https:servermono.com"

  font "www-server-mono-#{version}fontsServerMono-Regular-Italic.otf"
  font "www-server-mono-#{version}fontsServerMono-Regular.otf"

  # No zap stanza required
end