class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://ghfast.top/https://github.com/irmen/prog8/archive/refs/tags/v12.3.2.tar.gz"
  sha256 "aba6dac673944129ca96e600ffd7e03c122a15e2015978a431bbdcbd9ac89a73"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80bf0a7ab61a6b6f1614fd44a9a3f5607aadbbbf72842ef3a57ad3dff130ffc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694c56625db1ffc1d706454603445cf0b44860a24f9b8988a43e478cfb9c6d6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78b3e3deaf665e2e06a33304aa2d9bc48eee31f4583de95ecf894922ebe3c7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd144766ff9a02fa0f9ee6359817a7f7e0a044e5ec03dae7a8cb6eed82d8a067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b84af0aecd3c7f01dc7f2ae2d30b432cef0d041dae705c637eed9c4f4029fdc"
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