class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https:hledger.org"
  url "https:github.comsimonmichaelhledgerarchiverefstags1.32.2.tar.gz"
  sha256 "62220064622af4b3d8e373e3ba4f913c6011f2d7a4139d529eb88b2a1dac702b"
  license "GPL-3.0-or-later"
  head "https:github.comsimonmichaelhledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https:hledger.orginstall.html"
    regex(%r{href=.*?tag(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1639e58ddd35e7489fd8df8eff5deb06920bcc23a99a7d06c6258c6d50afe95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36bc31f963239d865c6de047670b0b6246d2ca97ef42044e9ceb9a905bf6bc3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6eb187ececdd03fc2abb97e425aa37052f47dc38eac5784d032dbf523f8e355"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed3f44ff0f9422d89e7a7f22825d89744cfa210c1cdf2d325402c7d20ae17ebe"
    sha256 cellar: :any_skip_relocation, ventura:        "038e6c4bfc385173fddc90eea7df427da72f38179da66ba0e03ecc61a3dd97f8"
    sha256 cellar: :any_skip_relocation, monterey:       "26c8d34ecc115a403fde67609c8c2e9c3c9f56f01ee30b16e7dd85334b7b6766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86b8580ee3b344f7f45eb22a67cafc877c2dd0f6bfa70963adc957d442a7bca3"
  end

  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger**.1"]
    info.install Dir["hledger**.info"]
    bash_completion.install "hledgershell-completionhledger-completion.bash" => "hledger"
  end

  test do
    system bin"hledger", "test"
    system bin"hledger-ui", "--version"
    system bin"hledger-web", "--test"
  end
end