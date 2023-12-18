class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https:www.haskell.orgghcup"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https:github.comhaskellghcup-hsarchiverefstagsv0.1.20.0.tar.gz"
  sha256 "9de3f367f298e9efecf9e9c2d50b828cec3af8cfd391e3b235057822b75d8fad"
  license "LGPL-3.0-only"
  head "https:github.comhaskellghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "259f8770f24440b6e5aa7594134b1263c2cb66c155f78fca04a7ff55d7dd4678"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f05315c6f407f4dc560ed00bd7c4c7c4c86c9fa264e5c90ac9074b79040350c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e04caf7839e4da312f6db4431cb0ffbe882cd46b8e7d5c0a06565f8ca43ab666"
    sha256 cellar: :any_skip_relocation, sonoma:         "b894cd8dd9d2570f6ca6e814128904d293cbd8e35b628b7eb4ba318934077e13"
    sha256 cellar: :any_skip_relocation, ventura:        "1649af0010637b6ec7723044039a28bbf2f50b98e1b52dcd9c66bd669254e748"
    sha256 cellar: :any_skip_relocation, monterey:       "1dc45bf75bf42343f5e2d587d06e2daad75e21e1ff756c6026250dbf9aff8686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2fc50a099c577a15fefb25b51c0d957748866bb5a02ead57d82fc9d78c5ce29"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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