class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v4.0.3.tar.gz"
  sha256 "cd1c3361494d027c898a297bbf4067009ea677c4965c77f5adcfcfe6f84fc494"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "1751903737ae02827e0ef176ad8e40b2b1d2ad30fdef9753c645004aac774b35"
    sha256                               arm64_monterey: "7dae643d81f52c31ada03e301627383b1f2d7394410ef50041c43769b7ca4be7"
    sha256                               arm64_big_sur:  "1d41a7e1d168a85c356f8ad87fcb653776a483ba92ba5fc29a7ee57f6a0b7366"
    sha256                               ventura:        "01257d44cad86ac4d645f2a3d6d7eb39f7ab7ae5e4171bb71a109d0419d0fbb9"
    sha256                               monterey:       "84232efe69676b6370deb025484d25727757003536871f5aa388a83d78ba3e92"
    sha256                               big_sur:        "902e29ff395e1dce87c4b470024df822f0b9750bde67534c49209aa95ef65866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2677fffd93b2f2954132df017d8f1bead83936e512558913193502f3764012f9"
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