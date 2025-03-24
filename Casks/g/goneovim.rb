cask "goneovim" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.12"
  sha256 arm:   "3ee1c9d9c1052d93cd0f118841ecae30104c166153594f1639921a6f3d730bec",
         intel: "907c830573ba622789e390162e16e5d9d9730125e35f124b904a3fc80dab6fb4"

  url "https:github.comakiyosigoneovimreleasesdownloadv#{version}Goneovim-v#{version}-macos-#{arch}.tar.bz2"
  name "Goneovim"
  desc "Neovim GUI written in Golang, using a Golang qt backend"
  homepage "https:github.comakiyosigoneovim"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "neovim"

  app "goneovim-v#{version}-macos-#{arch}goneovim.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}goneovim.wrapper.sh"
  binary shimscript, target: "goneovim"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}goneovim.appContentsMacOSgoneovim' "$@"
    EOS
  end

  zap trash: [
    "~.goneovim",
    "~LibrarySaved Application Statecom.ident.goneovim.savedState",
  ]
end