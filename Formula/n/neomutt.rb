class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https:neomutt.org"
  url "https:github.comneomuttneomuttarchiverefstags20241212.tar.gz"
  sha256 "6fbdbfd7f4d028276f7f0b1d9fe2bb5ee67161857111824cf392ca1ff27089c8"
  license "GPL-2.0-or-later"
  head "https:github.comneomuttneomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "3b545a4bd19317de09f94547633ae1b6cd0ce416cee32314ac30e0d64baf673f"
    sha256 arm64_sonoma:  "fdf3778f743ae67d9a089abee1f0c65e4b14d94c89b15557dc1ba627aea19e53"
    sha256 arm64_ventura: "74c6461eac0b8a10d3d50e910b2c79a2100b7c13e5688455faf5b281b4d79002"
    sha256 sonoma:        "fad18f1641618497c906e887ff48d1477d674f5d406b34cc7ed55a545dde9a80"
    sha256 ventura:       "bc8705e2dff0b7353532709968d57538570c720c5d2f96fe50a23d06c88c9623"
    sha256 x86_64_linux:  "c040d19773772b8ef5325053fa3a10e6ad7afbf116d6547a8f0d989118fa8c76"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
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
  depends_on "sqlite"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"

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

    system ".configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}neomutt -F devnull -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end