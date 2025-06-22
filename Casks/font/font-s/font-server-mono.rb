cask "font-server-mono" do
  version "0.0.8"
  sha256 "2f8f9cd371ba908dabce464960ab310a8522fdd99670c6c9fbd2f3988a378f9b"

  url "https:github.cominternet-developmentwww-server-monoreleasesdownloadv#{version}ServerMono-fonts.zip",
      verified: "github.cominternet-developmentwww-server-mono"
  name "Server Mono"
  homepage "https:servermono.com"

  no_autobump! because: :requires_manual_review

  font "publicfontsServerMono-Regular.otf"
  font "publicfontsServerMono-RegularSlanted.otf"

  # No zap stanza required
end