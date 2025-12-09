class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://ghfast.top/https://github.com/simonmichael/hledger/archive/refs/tags/1.51.1.tar.gz"
  sha256 "2b41c9d43bd14a1a3851b0474e8ca0d0207cc78eb116665c49c0c215519c3c6b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "dcc93e37c19c06532669ce42f3828591d8f213f11a4a47a25ddc83f2d2f4ce51"
    sha256 cellar: :any,                 arm64_sequoia: "2fbac02e787cecd3265c1f8144dc813fbd79d2e0c7a7bc10037c5051c906d6d2"
    sha256 cellar: :any,                 arm64_sonoma:  "ee6fa414cd9d7a4f3fcbc10a64d9b6950b0eff8368a1b7f56b8e81d7bad20a8d"
    sha256 cellar: :any,                 sonoma:        "da8d5e2c93f945fe465af86b9af48ac920f17c207661f5b5d5a74d9afa426cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682b0c75310f62fc1e936ef62b07f6d10c02ab5084dac92bc19757962102b6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7eebfcd0a367c21aaac0f67c9fd11143496bfdeede95165b0266604f8bba8a2"
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