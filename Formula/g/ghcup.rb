class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https:www.haskell.orgghcup"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https:github.comhaskellghcup-hsarchiverefstagsv0.1.50.0.tar.gz"
  sha256 "3e151c19ad02e5baee45ae8718aa71c657e8d99528aadaec2de02f12d7a1a1ae"
  license "LGPL-3.0-only"
  head "https:github.comhaskellghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d84257dea675bce7e7bc0b2c90755c5445f592b88bc702c0d48fcd14abd9ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2731940fe1d34f4065126e02654953188123e19b564d887f928d0555ecd97a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62b37f98c1c15c27abc5aef08f94dff350d8b6333185a4859a362c3fc2daed22"
    sha256 cellar: :any_skip_relocation, sonoma:        "976082ff7d5b504be21582b1a6a8dfe7d31a5917299bd3e9faa109421857f9c6"
    sha256 cellar: :any_skip_relocation, ventura:       "0330def4d1de7699688cbaf172929aad87e17f9fb735930707c81b6efe2e7a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cac7e64e8ff55b5df0ca6222c7fae07dc29057c049e8257cdb5933e7175bd7f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scriptsshell-completionsbash" => "ghcup"
    fish_completion.install "scriptsshell-completionsfish" => "ghcup.fish"
    zsh_completion.install "scriptsshell-completionszsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}ghcup list")
    assert_match version.to_s, shell_output("#{bin}ghcup --version")
  end
end