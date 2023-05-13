class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://ghproxy.com/https://github.com/neomutt/neomutt/archive/20230512.tar.gz"
  sha256 "44a6c9d8e6f58c6a3b21b6af5f044ffd0ed2deb1a7cdc6bdda14669917bd09c4"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "b9a96c2c9f1217ad7bf5fbaac79dcb28fd67002b2876d92135c5fadb0da19f4c"
    sha256 arm64_monterey: "ccc9371c53a3e0949f52e8f3299209b6ad394d840bef74a81b6534d58e9d809d"
    sha256 arm64_big_sur:  "2d8a0d0d8f5a25360489459b5fc82aeadd448889b18eabf51014f4ec04600a54"
    sha256 ventura:        "40edbf93f35700d3e169782331e63c52c6f4d4b393cc855ad51d591a42eb92bd"
    sha256 monterey:       "65789156fabd18cca7e9cb1c066ec65421d64a03df113a6eab823e796562dcae"
    sha256 big_sur:        "9d8ffe8d05b87cefbe64b0b9d62d43448bae88bcbf4f2e7c35838c156937f6c7"
    sha256 x86_64_linux:   "6e94a6cdec212be091712b251e5a30752b5922252b4d67ddec88cb5d0b38eca6"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --autocrypt
      --gss
      --disable-idn
      --idn2
      --lmdb
      --nls
      --notmuch
      --pcre2
      --sasl
      --sqlite
      --tokyocabinet
      --zlib
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end