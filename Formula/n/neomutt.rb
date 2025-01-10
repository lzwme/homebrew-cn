class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https:neomutt.org"
  url "https:github.comneomuttneomuttarchiverefstags20250109.tar.gz"
  sha256 "597325c23ad07310ed96b2ee566e45e489cca81b0bdb028f276c690143500f8a"
  license "GPL-2.0-or-later"
  head "https:github.comneomuttneomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "2a5e6bec9e3acb1849a85b0aeecc79f798d9e1ba7676575b5cd81eb339505a14"
    sha256 arm64_sonoma:  "27b7979211c5d89b49f5f603106fb8e034d144bf5017daa3e2928bbc9d39fa31"
    sha256 arm64_ventura: "48436a322e3bf175aa01d24eb983324a9d11b8990363a72d27e5c8904b4943da"
    sha256 sonoma:        "5fae8b6f0b4fa2bd9c7d77b5d0223ac6795854b0f1c09055157fa1d3bda9266a"
    sha256 ventura:       "a01934033be33ef62b1de189af0d938d27cd1401f4774c74261e4d009882977d"
    sha256 x86_64_linux:  "02c31ee06402d41758e2f310c92ced89aa6e2f95501b20c40b51e259dd9bf306"
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