class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.12.3.tar.gz"
  sha256 "df234817047bb58e25bb7625b3c3f8514a4ab9346e2fb9e9209c4b7192b67bd8"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "c262cde13414a008c53cd01a225545c04dceef581b4cea142416ebccd8e127be"
    sha256                               arm64_monterey: "f156bb78ef5a1ee935a71de783ee0dae545a822281bfb0cd8bc0606d1e01d95f"
    sha256                               arm64_big_sur:  "9518d9b3824f78c62d2f2236a7e61a8418d1bfcdc42597498687a085d189c848"
    sha256                               ventura:        "c8faf035b85667d5e1175ad4a897461513613c68d52720eb534af61da66aa31d"
    sha256                               monterey:       "9952371d51180e5b50c78cb5bf12f73479a6b40d5ac47cf16023cf7d964f6df9"
    sha256                               big_sur:        "40d2bfc615177400db5c36652abd22c5039821f84414ea9ceda33deaac5090ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e17251097242c0e0b939098f677ea4865ad5b9ff383a6f377511070fec36888"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end