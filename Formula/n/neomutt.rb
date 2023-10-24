class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://ghproxy.com/https://github.com/neomutt/neomutt/archive/refs/tags/20231023.tar.gz"
  sha256 "2c3e9515d5810f9efd547d12b2301b9fa92d979aa8aa74a05780073f22c9bf0b"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "d979b150c9b6786e9da533c012114b4beb430a0b22cfc2300a9e2f267b4f5094"
    sha256 arm64_ventura:  "525168a989782af1bd26605e0714882570bc9c77e516f4bd5f7bd9a7f34937e6"
    sha256 arm64_monterey: "d1a38c427a464b26e9962d47dae77148dae06875b8a0e52fb9c57ac80ca8b9d1"
    sha256 sonoma:         "6f46f84e86f80a1d2897bb9aa04b35a7009d1a9d0205ab379290835414e61a00"
    sha256 ventura:        "4d65c8c42b707e4f684ce2a7dc2d7c673163893ad2aae2da9d313448290adf88"
    sha256 monterey:       "2b285e94e4d5181c49ddeb6ff2c9716e01ff48742913d5ae79f4569f4977cccf"
    sha256 x86_64_linux:   "60fcb6ab38c8dda149e109d17fbc6cc67b8d2dbbadc39437d999cf582fb80363"
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