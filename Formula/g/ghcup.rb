class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://ghfast.top/https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.6.1.tar.gz"
  sha256 "c020f4f94ea0802805c6808f493f748aaddf47dae3d29e9561542aaf6af6999e"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1c14306cc711a938967647ec79e63665cf0d32b4015d9afaa3ad0e448f14e6c"
    sha256 cellar: :any, arm64_sequoia: "2ce17b8205a16f596732b606e152a092d7c6fc528187127386e66956482eef16"
    sha256 cellar: :any, arm64_sonoma:  "7af93d6ab9b8290e777e28003da6dad580db32b30e8cb3ca88aeb8ad2871032b"
    sha256 cellar: :any, sonoma:        "87fe68331c12804384e58d872e0583a767d34933412a9601f94932173e030a5b"
    sha256 cellar: :any, arm64_linux:   "a4036e588e516b738d422ddfea253de116723cb4b4a0ce0dac25ec8e292b03af"
    sha256 cellar: :any, x86_64_linux:  "c86a2e121ca673d82ea79d825b48d61dca1af66d87d912b6f7439bb4f9355cb1"
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