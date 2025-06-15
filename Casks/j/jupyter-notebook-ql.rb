cask "jupyter-notebook-ql" do
  version "0.2"
  sha256 "f3a39ba316a32cd3ba63e2274e2d3355a0ef639f6e79c2eec40d462020599653"

  url "https:github.comjendas1jupyter-notebook-quick-lookreleasesdownloadv#{version}jupyter-notebook-quick-look.qlgenerator.zip"
  name "Jupyter Notebook Quick Look"
  desc "Quick Look plugin for Jupyter notebooks"
  homepage "https:github.comjendas1jupyter-notebook-quick-look"

  no_autobump! because: :requires_manual_review

  qlplugin "jupyter-notebook-quick-look.qlgenerator"

  # No zap stanza required

  caveats <<~EOS
    You need python 3 and the nbconvert module to use this plugin.
  EOS
end