class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://ghproxy.com/https://github.com/vermaseren/form/releases/download/v4.3.1/form-4.3.1.tar.gz"
  sha256 "f1f512dc34fe9bbd6b19f2dfef05fcb9912dfb43c8368a75b796ec472ee8bbce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9db94c3342b5744b787f9950b3b5931f2b4a1d55daad02352d3daffde5d6b376"
    sha256 cellar: :any,                 arm64_monterey: "ddfd7b8d84cc991ca0ccaea83bab5135535d5a4d96f4daca1dce9b89b18f7992"
    sha256 cellar: :any,                 arm64_big_sur:  "e30e69e4931094eafe38a8c2d25966b86f0df3a8aacffe5480cf0098b84d97c9"
    sha256 cellar: :any,                 ventura:        "fc08ffd719328fbd615fc269e7a0a70ed51b1d365abdbd336361ab3645a90d63"
    sha256 cellar: :any,                 monterey:       "4e4183cd34e538a43a6cfcb99ef054ab75786e40088806aed7d61a54950869e5"
    sha256 cellar: :any,                 big_sur:        "62ddb0717b667323815d8a35c6377bb479be7ebe6ceb5e331d341191d6cb0e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bdafe12587a3d4a8f64c28024b01ba0137e81ae5ceab40c865614544c66eb89"
  end

  depends_on "gmp"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-native"
    system "make", "install"
  end

  test do
    (testpath/"test.frm").write <<~EOS
      Symbol x,n;
      Local E = x^10;

      repeat id x^n?{>1} = x^(n-1) + x^(n-2);

      Print;
      .end
    EOS

    expected_match = /E\s*=\s*34 \+ 55\*x;/
    assert_match expected_match, shell_output("#{bin}/form #{testpath}/test.frm")
    assert_match expected_match, shell_output("#{bin}/tform #{testpath}/test.frm")
  end
end