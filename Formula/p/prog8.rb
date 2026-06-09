class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://ghfast.top/https://github.com/irmen/prog8/archive/refs/tags/v12.2.tar.gz"
  sha256 "731efbf7cbdfef2202e7e664f9c9ef2193662c613f2366dd323bb2af26abf6a8"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4394410424480a860b7c46d9e17a544bbe74252550ed50dfdb9dcea86365cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed695b23a80989394306a1cbd422731da3c0a27d4affbdd9572d4252ba207c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32015534fed4cfc76093e52678806ba74cb353b62059c5e679385855374757e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5d2aa66dbb29942c14105231f570407dc2b4af49998fe787f553fbf90da070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf78de2d1ec83e235686a097c9e42c09b0b00e1f9fc781b3f067a4fbfb93171e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0970031d7b075492c30a4263021c4c673305e4a3fd14a33f528c66b4142b3b5"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: Formula["openjdk"].opt_prefix
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", (testpath/"primes.asm").readlines.first
  end
end