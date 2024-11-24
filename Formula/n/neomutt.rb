class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https:neomutt.org"
  url "https:github.comneomuttneomuttarchiverefstags20241114.tar.gz"
  sha256 "044bb5a37d5095016569a1b505f7c2f7d8b93e90ff95c2edb82830313319ce9a"
  license "GPL-2.0-or-later"
  head "https:github.comneomuttneomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "0d836ad684cb2021c7d15c4a56ea534bf1019878136a4aae255c116ad0e64e12"
    sha256 arm64_sonoma:  "a3613569f907c7ce51570b35053fdc4121f0d9055454f7255676e39e5e073dfd"
    sha256 arm64_ventura: "8457226154aadeca7bcb129911b43ba7113181160ca953db12d0f17eb80478f5"
    sha256 sonoma:        "3529a0f181a8548a2abd89a69c146b0b348e25073be559cf4a6b0508dd29ccb0"
    sha256 ventura:       "70d87820a0ac9f34978230a9b84fc38d5b7b0dce6ac9c5f3dd88bd1347d72d59"
    sha256 x86_64_linux:  "0415adbbf45dfa3318210777f99736331956b9f847c96114e90538db1c5c8c20"
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