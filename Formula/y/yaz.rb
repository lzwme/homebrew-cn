class Yaz < Formula
  desc "Toolkit for Z39.50SRWSRU clientsservers"
  homepage "https:www.indexdata.comresourcessoftwareyaz"
  url "https:ftp.indexdata.compubyazyaz-5.34.2.tar.gz"
  sha256 "ab45cf48036fc6da7493815c033b5db2b1e7a34632caed1a43e9cdef745b9618"
  license "BSD-3-Clause"

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https:ftp.indexdata.compubyaz"
    regex(href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cdd2614e6bb233a8e1d721ad1579ae1f52704c8c97c240143628e67d11a78d23"
    sha256 cellar: :any,                 arm64_sonoma:  "f5f775d569c087f4d6b9eddce40f330e27a04d88e1cc08266267683144578511"
    sha256 cellar: :any,                 arm64_ventura: "fcee21602cff1db846864202217e5eee1b73a419dbf21f7e49f4ce84fcc4d155"
    sha256 cellar: :any,                 sonoma:        "e4cb4a988e746915b5d812350124c76e831440ae50e2570362c9930d7ae84e0a"
    sha256 cellar: :any,                 ventura:       "19ebfe9d7bc5f382086866410ced5f1ba8aa821c499cc682651b6025a69a56b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d4ba3db077ddbf7cd73204859c8dfabc7e446f77c60e18314efb02e4838956"
  end

  head do
    url "https:github.comindexdatayaz.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook-xsl" => :build
    depends_on "libtool" => :build

    uses_from_macos "bison" => :build
    uses_from_macos "tcl-tk" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "icu4c"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
      system ".buildconf.sh"
    end
    system ".configure", *std_configure_args,
                          "--with-gnutls",
                          "--with-xml2",
                          "--with-xslt"
    system "make", "install"

    # Replace dependencies' cellar paths, which can break build for dependents
    # (like `metaproxy` and `zebra`) after a dependency is versionrevision bumped
    inreplace bin"yaz-config" do |s|
      s.gsub! Formula["gnutls"].prefix.realpath, Formula["gnutls"].opt_prefix
      s.gsub! Formula["icu4c"].prefix.realpath, Formula["icu4c"].opt_prefix
    end
    unless OS.mac?
      inreplace [bin"yaz-config", lib"pkgconfigyaz.pc"] do |s|
        s.gsub! Formula["libxml2"].prefix.realpath, Formula["libxml2"].opt_prefix
        s.gsub! Formula["libxslt"].prefix.realpath, Formula["libxslt"].opt_prefix
      end
    end
  end

  test do
    # This test converts between MARC8, an obscure mostly-obsolete library
    # text encoding supported by yaz-iconv, and UTF8.
    marc8file = testpath"marc8.txt"
    marc8file.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    result = shell_output("#{bin}yaz-iconv -f marc8 -t utf8 #{marc8file}")
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result

    # Test ICU support by running yaz-icu with the example icu_chain
    # from its man page.
    configfile = testpath"icu-chain.xml"
    configfile.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <icu_chain locale="en">
        <transform rule="[:Control:] Any-Remove">
        <tokenize rule="w">
        <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove">
        <transliterate rule="xy > z;">
        <display>
        <casemap rule="l">
      <icu_chain>
    EOS

    inputfile = testpath"icu-test.txt"
    inputfile.write "yaz-ICU	xy!"

    expectedresult = <<~EOS
      1 1 'yaz' 'yaz'
      2 1 '' ''
      3 1 'icuz' 'ICUz'
      4 1 '' ''
    EOS

    result = shell_output("#{bin}yaz-icu -c #{configfile} #{inputfile}")
    assert_equal expectedresult, result
  end
end