class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://ghfast.top/https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.6.0.tar.gz"
  sha256 "d418c01aa2fd9be76b98460fa22c443a386eb924df6f9e9f94a877cffcfcaf02"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf4b379ffff5c5c45cacdd06d0ef047ec474737fb591ee81938d0b6723df751e"
    sha256 cellar: :any, arm64_sequoia: "91682c9cc67f05b803a923504a6167760f19f3093e961b0e70b156f1507ac4ee"
    sha256 cellar: :any, arm64_sonoma:  "827e7a9729c387aac996693c43330999ff28b0ab243be57f7b18f74dfb4a4173"
    sha256 cellar: :any, sonoma:        "49dea1165feb4e299e213524a13823d85a98ee89b174348b60d8178d0c330916"
    sha256 cellar: :any, arm64_linux:   "4c725eff420dd7d4dbb2c1723514be7a0ea6c15e9653d75fe331adcea203851b"
    sha256 cellar: :any, x86_64_linux:  "be110257294b7378820b0e72b1e10b4ef0ae6dd14aa798bb0e823548a0bab6de"
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