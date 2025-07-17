class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://ghfast.top/https://github.com/oracle/odpi/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "a22c37cbd362389e02a599282d27d4e98b05438d61c5957cd2b5ee97238de9a2"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a48e1f1ddfc46a960b733b91f1155bf1e4a159e62b4dddd2081b63ef554bd73"
    sha256 cellar: :any,                 arm64_sonoma:  "339ff48d94669dc1c30486baa2114401cb8971f45583a4e40a6ecab2ef26d6cc"
    sha256 cellar: :any,                 arm64_ventura: "b20387f17bd89b0776235efd68db05b1cc05f3c34c84b626779948b1815c23b4"
    sha256 cellar: :any,                 sonoma:        "e33f5f04c62be62922d5fc40377df730a52a0c83dbf3f373b1cc4042602a1d12"
    sha256 cellar: :any,                 ventura:       "529f0094d037bd6f40b0808125c9f8f6a0c6ff6f786777c7a65ca031150bc9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c922f2eb582aa3047c681fc14a938262d1226ef2cc39f1caebc274092377b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99134681181e2721c0313a3778f0234445bbe58f72ba0357e3b119f9c842be19"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end