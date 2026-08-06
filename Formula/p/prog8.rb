class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://ghfast.top/https://github.com/irmen/prog8/archive/refs/tags/v12.3.tar.gz"
  sha256 "40d86ee9c4d77d3b36151f979221d7ed06a106f16fa2602e5bdae8d815844e34"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e489ab1ea9dff1d1fe56dfafdc84c68b94526572e21785fee9d04c171334729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93e2629e20b698ef1b9d0304010c5c59f7ded91a07d26d644a17da7aab63a931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5868a4b94bf0f38bf65c250f888829fa64fc57b86c677be6d1dacb954820f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c750f6793e9c898e2205b1f31a9ed299806bfebf4da07d9e9bed49ebaa2f07c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578e8e12b2270a5b35df9d0b0109012a9df58a904ea5ce8fca0719b5065e77a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3357df64aeebd096593d8f19450bc88ba585c33a2dafd154aa06956727da82"
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