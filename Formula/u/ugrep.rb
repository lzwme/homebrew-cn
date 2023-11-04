class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "32035bb35c98e1f249e1273d135630eb98aa6992e8fe56297a957dd1eb9053a7"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "41966aece715b4889566aeb906dc42d88adae49066c8818cd7709df5d872b1fd"
    sha256                               arm64_ventura:  "69d33c227d7d43a62f16f012fcb5b2463a555a6247173a74b369a52711b5399d"
    sha256                               arm64_monterey: "6e6c31d62bd953451baa61d98e8088c9113ca73d56bc0ef79686b32da24712fe"
    sha256                               sonoma:         "7aacdf13b4e430d5442ca762dc7c4321e2e9d8493608305b3b61d8105b057f8c"
    sha256                               ventura:        "d4daf31034905f6e46f869cf1a27c3a1056e0499f5c905663654ba4ceff361b2"
    sha256                               monterey:       "74202c28a611f23c43cee67c733a7820d41961869f5844ad8192f448d9ff718e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d97f56340d164abd6aa2cfde41f9059d7afbb243e69c84be8353103c173dc6b6"
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