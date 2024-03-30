class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https:neomutt.org"
  url "https:github.comneomuttneomuttarchiverefstags20240329.tar.gz"
  sha256 "241e354b4b5af846f00926f30c0a04e959997556d4cb409c4ff297f398cfc104"
  license "GPL-2.0-or-later"
  head "https:github.comneomuttneomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "1b2a46d81d9450e65baf35846814a7dbf30634b8d555c6fdbff4551a40dd8c61"
    sha256 arm64_ventura:  "2d16810365fc460fbf68ec487675bd92fee7883615e17cc8547b9e0929061156"
    sha256 arm64_monterey: "ac1daf7e99effb8521dfab9424bc17937990dc85454bc5bcd19ad591af866bfa"
    sha256 sonoma:         "fe56424f02473a3659810d62a13424560636382cf7d0c95b2d047524a1733b1e"
    sha256 ventura:        "1139705159a5cd48f4b9570094e11cc6d23fad6bdff695c12348f978f05639aa"
    sha256 monterey:       "e2624c2a044daff3f175a0882f3fb2b6a0cc8a7f58ee140b8b3d6da856456f65"
    sha256 x86_64_linux:   "2268434d5da12b29a867369ce0155330d45d8e907345d07294d3e10550a7901b"
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