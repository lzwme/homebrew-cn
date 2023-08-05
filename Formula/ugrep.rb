class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.12.5.tar.gz"
  sha256 "5ff60ea5b5f2fe2068bbc0b0d9072fe55eb310e094588bdb2324d9123aa92114"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "6c00a0636a8adf91782116f76e52160702d8fb66d690a28496454a8592598fd8"
    sha256                               arm64_monterey: "7669f6d1a5f68b12d48c660fc1d30f791dd19b5a7986db3e1b44719383e4f415"
    sha256                               arm64_big_sur:  "ab08e64ee417f0a7ebde57f176312102cba403aba19f78c157413298e22f8939"
    sha256                               ventura:        "431fd4946c3ae5a5d7391aa45cc837354c325b99239e5fa77938aba789401b32"
    sha256                               monterey:       "fc1257ecf49826adbd75f0259f1b68ffc5ffb22b43026d3ee894026713000332"
    sha256                               big_sur:        "abe5b2e40754d57a476ac5f47210b33429197beaabf2d4f05400d87fbff2dd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6978e6789f87fcee0ce48a7c03d0ae9f860848132ce46937ecbe180d46da3fb3"
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