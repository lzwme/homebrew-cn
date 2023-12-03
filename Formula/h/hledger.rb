class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://ghproxy.com/https://github.com/simonmichael/hledger/archive/refs/tags/1.32.tar.gz"
  sha256 "50a93ba0953bd8ec776afa63c60305567f3b5f1c01e9bf74499c2faa9c169470"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18997daa473331b835d6c3e92cbb77f204ff55b6459a4ac0d9583fcce62dfddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c09d1891d57089c095fbdb834ed13edb5b275a56d90884b86386e6c601e129e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69860e369f4a98075509ce60cb80a2ea0a590a7ef738fdcf0b991405a826da38"
    sha256 cellar: :any_skip_relocation, sonoma:         "f848338939a7ce37ea83812e12a6dc9b843b6a6fb36bca9065576db80069bc6d"
    sha256 cellar: :any_skip_relocation, ventura:        "5b210ad4c280235d9873269316d4193db176813a7c8c8116917ff9a496577fec"
    sha256 cellar: :any_skip_relocation, monterey:       "a9805867e1f7a8449396d719da5ecaf9f16afdaf7a40a5233d2f6e7b29537130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a3b1269f439b798c238b7ae21af512283b4ecafad0092885863feaf90f4072"
  end

  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build

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