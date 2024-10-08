class Yaz < Formula
  desc "Toolkit for Z39.50SRWSRU clientsservers"
  homepage "https:www.indexdata.comresourcessoftwareyaz"
  url "https:ftp.indexdata.compubyazyaz-5.34.2.tar.gz"
  sha256 "ab45cf48036fc6da7493815c033b5db2b1e7a34632caed1a43e9cdef745b9618"
  license "BSD-3-Clause"
  revision 1

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https:ftp.indexdata.compubyaz"
    regex(href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a44b7c5887c5410210f7230a0e93df46cbf48e60b2143758bca4474085471e4b"
    sha256 cellar: :any,                 arm64_sonoma:  "59f257290e52e8a37120a212aebdd115bd4af7b7626e33eea8723837febb4aba"
    sha256 cellar: :any,                 arm64_ventura: "ef0e15a7a7b4b15bd4fb0d96adb25e78c13923a72e39b8782532eb491a56e841"
    sha256 cellar: :any,                 sonoma:        "222ffaea50dbac82503e2c18962b36e48df74b71ee37a2106df5df20d042d3e1"
    sha256 cellar: :any,                 ventura:       "427fa3664a5f33412422f793a0a3ef9807908df1a19fc43c39346a923e152797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4889df9aa745f8b29329d00159ace539d451bbb71f4714604756b1496d3780a4"
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
  depends_on "icu4c@75"
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
    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(^icu4c@\d+$) }
    inreplace bin"yaz-config" do |s|
      s.gsub! Formula["gnutls"].prefix.realpath, Formula["gnutls"].opt_prefix
      s.gsub! icu4c.prefix.realpath, icu4c.opt_prefix
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