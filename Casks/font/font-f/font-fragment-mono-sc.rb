cask "font-fragment-mono-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflfragmentmonosc"
  name "Fragment Mono SC"
  homepage "https:github.comweiweihuanghuangfragment-mono"

  font "FragmentMonoSC-Italic.ttf"
  font "FragmentMonoSC-Regular.ttf"

  # No zap stanza required
end