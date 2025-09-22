cask "ipynb-quicklook" do
  version "0.1.5"
  sha256 "b8d1b10b79d35d3c60537fef34c20bbbe52808c8fc4ad673b862e7094a265ef5"

  url "https://ghfast.top/https://github.com/tuxu/ipynb-quicklook/releases/download/v#{version}/ipynb-quicklook.qlgenerator.zip"
  name "ipynb-quicklook"
  desc "Quick Look plugin for Jupyter/IPython notebooks"
  homepage "https://github.com/tuxu/ipynb-quicklook"

  livecheck do
    url :url
    strategy :github_latest
  end

  deprecate! date: "2025-09-22", because: :no_longer_meets_criteria

  qlplugin "ipynb-quicklook.qlgenerator"

  # No zap stanza required
end