class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://ghfast.top/https://github.com/irmen/prog8/archive/refs/tags/v12.3.3.tar.gz"
  sha256 "6cee4a7faa2596e3e83230e9219eb7ad195557dab66106dfe94fa7cf8c72c55c"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "213f26095829e7f18f09f23a1ef31a41431dc461552550b8a47b90111daf218c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6182497ec9bf077d01fc04f7134d0a1b9ccb4253a769652d7c33d212968657bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b286c86e51dfaf56447c7c6f98fd0eae2d3b617db3df7606d0d3f9307b8f705f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f60bae2d3764e88a4e1ea47577a18d6cbd943df58950b1c169613a4b3dbf71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4efb496a982ed9931f2344aaf74f855e97efee430ab4dbd9dc0aeb53700cdb05"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: formula_opt_prefix("openjdk")
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", (testpath/"primes.asm").readlines.first
  end
end