class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://ghfast.top/https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.3.0.tar.gz"
  sha256 "b037c2c6de805bca16694492a5eb40aa87368badd62d092605aa2b029b5803bb"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2af624ca54689add86fcf9e8a7925ffa73d7ebfe02058d7008eaa36fce7ea56e"
    sha256 cellar: :any,                 arm64_sequoia: "4dd693d840087e4c9c469c43e196f0f00542d564ff8b3fd8b932b0b86d06188f"
    sha256 cellar: :any,                 arm64_sonoma:  "06c9363a159e0a8fc49640662eb1af81d50e5c07c3b3c9ea3315e6ea67b23c41"
    sha256 cellar: :any,                 sonoma:        "593afc173c5f71546778936b7fe672cb6b0671debe67b8b37a558ca52380a267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169833de59df5b7e9e4933765c4d825e1c346feae22051a8d563316f13697a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64502cfaf29812de53f3d3cb4e1b8546396cfaf1a1da3c03381884be1a18381"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end