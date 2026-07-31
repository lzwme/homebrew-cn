class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://ghfast.top/https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.3.tar.gz"
  sha256 "0bdda243e7dcb3231943a7b72b3e73cfad95be56c297d049c6037ef14ae03d7e"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "7142109b0e858e0c426fec6f44f1e5adf752fe073657bc168ff537ab669bae10"
    sha256 arm64_sequoia: "3b333d3333a4f969d9609661dcdd444300a15bcc82e1cf04774d16cac17b67c0"
    sha256 arm64_sonoma:  "a047fe7efa5a2749171bf42c0359334448f24d3888f5736d579251bc27c955fe"
    sha256 sonoma:        "ac655da3d200ee3f51fe67f5b9549fe33eaaa1602a288d311154c551f98d5faf"
    sha256 arm64_linux:   "f0a51f943ad8acf7426e3d40fb1f7e18707a39867c8c4f53e5101a332b3eaf2c"
    sha256 x86_64_linux:  "f57dd9b0709e6ada8a16a114114f09d7502d4dbe7efa59afe9741f2c5a7f9d81"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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