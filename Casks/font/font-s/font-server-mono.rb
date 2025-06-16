cask "font-server-mono" do
  version "0.0.7"
  sha256 "695f201ee89614f5aa95ef37d0958fbcee877b7782fb1877717b164228eddf58"

  url "https:github.cominternet-developmentwww-server-monoreleasesdownloadv#{version}ServerMono-fonts.zip",
      verified: "github.cominternet-developmentwww-server-mono"
  name "Server Mono"
  homepage "https:servermono.com"

  no_autobump! because: :requires_manual_review

  font "publicfontsServerMono-Regular.otf"
  font "publicfontsServerMono-RegularSlanted.otf"

  # No zap stanza required
end