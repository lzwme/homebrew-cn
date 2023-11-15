class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://ghproxy.com/https://github.com/neomutt/neomutt/archive/refs/tags/20231103.tar.gz"
  sha256 "d8712c8f852f1cae4d5f53d8f7db3d2cc7ce7a11f54df3fc6e5417995d02bae8"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "6d49fcf5dd81efafe06f36203bbfb08a91d2a8d3009d2e1422ef01279a5941c7"
    sha256 arm64_ventura:  "2ee309bf5d98b00891d9dd744b06066ddcfed0ca52b2eecfbe572f732151e3a1"
    sha256 arm64_monterey: "b4dd35cbe87c8d66807ac1e18edbc3e3830e5ce04a5a551b6cec9bd8ba0891e8"
    sha256 sonoma:         "bc5a0881c9e438a5d926111da3371bc6950487946205a591f1f597ef9f427f1c"
    sha256 ventura:        "a55303858d5b75f9ba83809e583657bd51e1b1c474e999ac17b348aa4df4ee35"
    sha256 monterey:       "d2043c07e7c4bc6565106fea6a8bb1c4265b9f1d5e671547d4914c293bc41d6d"
    sha256 x86_64_linux:   "d64ede90ebca988fb11084a0bea120f502906b711709336495400ff89d7a4985"
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

  on_macos do
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
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
      --with-idn2=#{Formula["libidn2"].opt_prefix}
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--with-iconv=#{Formula["libiconv"].opt_prefix}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end