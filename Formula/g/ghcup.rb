class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://ghfast.top/https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.2.0.tar.gz"
  sha256 "1c298302445061bf5e2c776971020ce71b357a5d8871c97c965b166e4ecc934f"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fda1fa838e57b583e11276b7a07fd173e53ed2c8b4b2fd9c6e5c9a92eb55c84f"
    sha256 cellar: :any,                 arm64_sequoia: "7204cd8891e58cf9bf709cfb9cd2b09b35e837a65a6fff6c40a572a65e7aa33d"
    sha256 cellar: :any,                 arm64_sonoma:  "9c741a78aeb1e5ae99315ea40a2ab75a1c1b04474cc5e4fbad4d89f599e47a45"
    sha256 cellar: :any,                 sonoma:        "6d30c5c4316a561f7b70ca2ed901a4daa79e1f37e0cffe60f8e8e2d92e8b612b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835feba7f6436857f0945e0f2bbac6fe4b4ec6c6146a6d2bf5c8b0481869b4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d27db37b377dc67891131bb086735cc01d1a7b7f8ee830b5bd6f4fd7e944d3f"
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