class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://ghfast.top/https://github.com/neomutt/neomutt/archive/refs/tags/20250510.tar.gz"
  sha256 "12d225e270d8e16cda41d855880b9d938750a4f1d647f55c6353337d32ffd653"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "4760321fe8e61cdbc564c3d383ee48e7c63109e9e9fa7fdbe3672631123db0b9"
    sha256 arm64_sonoma:  "525364112b08a77bdf4b3a8b1cb7778c96ee1769be95d337c24bce7c5b703ebb"
    sha256 arm64_ventura: "434c5655c1f147070de38a082d91b72b629cc230451b05d41774aed04f1265d2"
    sha256 sonoma:        "ce4502877c4867eee8b2bf0a0e1c9daf44c9b266fa2997ec883a26baef19eaec"
    sha256 ventura:       "aea560a194d7d540c6ed953af77437dca80963ca7cfb3fec212f1ecd31db75c8"
    sha256 arm64_linux:   "b9a2df0e6f3dee00944d02949a312c91f26b990c34a9cc04154391a2943d84e6"
    sha256 x86_64_linux:  "ce77dcf1bafb0d760900c799ef73636df2c2ef3dd622f63d4a1b1de53527d40f"
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
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level", 1)
    assert_equal "set debug_level = 0", output.chomp
  end
end