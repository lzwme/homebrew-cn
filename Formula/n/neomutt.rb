class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://ghproxy.com/https://github.com/neomutt/neomutt/archive/refs/tags/20231103.tar.gz"
  sha256 "d8712c8f852f1cae4d5f53d8f7db3d2cc7ce7a11f54df3fc6e5417995d02bae8"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "4d0a32e3443ca4d42e12c83d4e877e480ae43c7ef194b90092ce45e6d60286da"
    sha256 arm64_ventura:  "38a3a1a18d863032e20bd287650a7415b632b6b97f146c4901b86857b9d8c607"
    sha256 arm64_monterey: "98c49a3a39434aa23b8a84039695f6e5e31e6070f8a7efba38a9e912b12fb896"
    sha256 sonoma:         "f5a020d2d0915bb63779490d8a8bd563ccb14a926c56c1f0c6693839519d4d43"
    sha256 ventura:        "ec4b78adf8a88ae88e56b4724df8b41c0173a420b0a123af67c8d60d26134815"
    sha256 monterey:       "d5f20eabb547c20c79403b98fa6660db0af3488af2bb06adc95112661473171b"
    sha256 x86_64_linux:   "1a5e0163d5cf1d10695f7a55511552eebafc4c7a98800f62f058f6400f0e1159"
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
  depends_on "openssl@3"
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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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