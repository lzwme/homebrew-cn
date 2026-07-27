class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://ghfast.top/https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "d02fcd21f75c1b834133a12b1522f92cbf456be4e9cdabdef7cb8ce378ff2e79"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3bfcd28f9ea3538e224fae5c07f3d944a81889c3c4ab5c4b6cc78ec5ecc3dce9"
    sha256 cellar: :any, arm64_sequoia: "81557fd71705be7db5cdc9b68c67c319a826586f50692e20d03855ede3bef7fb"
    sha256 cellar: :any, arm64_sonoma:  "4260cf989b1106e2abc99101bdf2cfbf05829e6fc373b0d979ef5ad9aa1ba5d6"
    sha256 cellar: :any, sonoma:        "0f9de7745e5f9fad52acd95523935ed82aaa488910c36d69c9b93a654afc9ae3"
    sha256 cellar: :any, arm64_linux:   "dd9328533ccf6f7457c25510e54203f7b4357b478474adc95caaba9d59d74b09"
    sha256 cellar: :any, x86_64_linux:  "cd4193bbd867ea0d2e31120dacbc5dd7c635ed882af9bce842faef9502fd182a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fftw"

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <liquid/liquid.h>
      int main() {
        if (!liquid_is_prime(3))
          return 1;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lliquid"
    system "./test"
  end
end