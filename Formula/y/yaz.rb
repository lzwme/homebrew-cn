class Yaz < Formula
  desc "Toolkit for Z39.50SRWSRU clientsservers"
  homepage "https:www.indexdata.comresourcessoftwareyaz"
  url "https:ftp.indexdata.compubyazyaz-5.34.2.tar.gz"
  sha256 "ab45cf48036fc6da7493815c033b5db2b1e7a34632caed1a43e9cdef745b9618"
  license "BSD-3-Clause"
  revision 2

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https:ftp.indexdata.compubyaz"
    regex(href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8cd36bbbeec630fa947578396b92b8ad37c0ba907f457f6618cc37240b2fb66"
    sha256 cellar: :any,                 arm64_sonoma:  "a2c3bf144a59efe29632027782e983de77e92f0aacade22b812c873433992dfc"
    sha256 cellar: :any,                 arm64_ventura: "8f6a66d5ca7c55b904adf90e11ca423e038bf387d1591557c715b94bbea0a983"
    sha256 cellar: :any,                 sonoma:        "c22b67c417f5ed789fe8e9b3785ebccdb49077d17ed9b158911472bc7734dbd5"
    sha256 cellar: :any,                 ventura:       "b9b0851e6eb1a3141f1667b685b05b1379d17c74fd6e6bc0b19fb0c78352a012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57fc1bff0c4788bf37030172238c5be3f2c0d2a0f93025c1c63f45869e86d5af"
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

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "icu4c@76"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
      system ".buildconf.sh"
    end
    icu4c = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
                .to_formula
    system ".configure", "--with-gnutls",
                          "--with-icu=#{icu4c.opt_prefix}",
                          "--with-xml2",
                          "--with-xslt",
                          *std_configure_args
    system "make", "install"

    # Replace dependencies' cellar paths, which can break build for dependents
    # (like `metaproxy` and `zebra`) after a dependency is versionrevision bumped
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
    configfile.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <icu_chain locale="en">
        <transform rule="[:Control:] Any-Remove">
        <tokenize rule="w">
        <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove">
        <transliterate rule="xy > z;">
        <display>
        <casemap rule="l">
      <icu_chain>
    XML

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