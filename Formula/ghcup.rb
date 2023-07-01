class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://ghproxy.com/https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.19.3.tar.gz"
  sha256 "4c74875665975e3a2cdf0c11cc7cc4cd2558308ef7a3f7f3689c57450b9172d0"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94f49d28ce442e0a685a278e2617b9443d57a4dc3b592d92af45733b38481165"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60081ee15d3a8bf2c977c06e6b74bbe083214cf41e1f388427e9d6230fab976c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1810cee7ed24cca73de00eb806fae98cb05320d1ccf4120b614b399052d264da"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9686bd1d29f8357b8eac44345a99e4e138c0892cdf8f08ca67f7382e6ae6bb"
    sha256 cellar: :any_skip_relocation, monterey:       "93b08f470550f0516bac16e343868bea0e228b99a0278e09d2a0298306a91bc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee6192061d78b37033cdafcb5c598e36c2533321fd1d78bbf38eb0f67f826d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f811f0a079480809be9386eb690eb33a889ebca6ec4dc34139813c7eda4aa8f9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end