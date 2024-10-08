cask "font-monaspace" do
  version "1.101"
  sha256 "7ff2317c7bdaed8e81dcbe1314e6ab12ad9641b7ddf921e996a227ff4ec7752f"

  url "https:github.comgithubnextmonaspacereleasesdownloadv#{version}monaspace-v#{version}.zip",
      verified: "github.comgithubnextmonaspace"
  name "Monaspace"
  homepage "https:monaspace.githubnext.com"

  font "monaspace-v#{version}fontsvariableMonaspaceArgonVarVF[wght,wdth,slnt].ttf"
  font "monaspace-v#{version}fontsvariableMonaspaceKryptonVarVF[wght,wdth,slnt].ttf"
  font "monaspace-v#{version}fontsvariableMonaspaceNeonVarVF[wght,wdth,slnt].ttf"
  font "monaspace-v#{version}fontsvariableMonaspaceRadonVarVF[wght,wdth,slnt].ttf"
  font "monaspace-v#{version}fontsvariableMonaspaceXenonVarVF[wght,wdth,slnt].ttf"

  # No zap stanza required
end