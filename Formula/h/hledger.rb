class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://ghfast.top/https://github.com/simonmichael/hledger/archive/refs/tags/1.51.tar.gz"
  sha256 "a0cc07ac604f215fb3971472f95af608373ea434633558906b470a5bac0e541a"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02c499cb97af380a03d9c819cafec5d71535f121cca7dee1d4e51387ab7ad87a"
    sha256 cellar: :any,                 arm64_sequoia: "43da4a902b6f15e5cf6ee1dd30928100446c4fc2231300776459efe520c5c365"
    sha256 cellar: :any,                 arm64_sonoma:  "1db85764c9498f6622406b1a3cbe440fdb682418abccb57340e696743d2f7b6f"
    sha256 cellar: :any,                 sonoma:        "a1cf2148c201d7b7b89ad8d7132c5d7014596ae3c735f5b4c655f355929381c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ad79e12fa30d6261a243dccd554610a3cd6a948c2b2ad1f5afa45535042a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24abc66c21377a60d6eaa81ef0ea4c25cbe79c660e9d939551b424bf88742b88"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger*/*.1"]
    info.install Dir["hledger*/*.info"]
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end