class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.36.0.tar.gz"
  sha256 "e9389ff5d7e76b4a50c89d72715a96a3ed48bbb97bd91b56eeb5146fa1be5d7d"
  license "BSD-3-Clause"

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f56088979fe27b1021fbc48a1501bce6e464e8f56c357fbb9ad644f25aac824"
    sha256 cellar: :any,                 arm64_sequoia: "db1bafac4e2be774244d6c930f816c84688cad54190777d3df7f27d5f696a6b6"
    sha256 cellar: :any,                 arm64_sonoma:  "c22db6d1969f1945b82a4f375fde237ec9471ae1eb903fe16b968cef8118dbda"
    sha256                               sonoma:        "cab7510395a7eb8787ae6b78c64b72306cd13c891481ebfbf1a3fa356343b3c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b94a1ce4543ff242a026ccb12f5162da86162947b504400faddc06e42bd869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51730918ed9aea291227fb19aac9694951e8ad917956e342a44ef18a92d629e"
  end

  head do
    url "https://github.com/indexdata/yaz.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook-xsl" => :build
    depends_on "libtool" => :build

    uses_from_macos "bison" => :build
    uses_from_macos "tcl-tk" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "icu4c@78"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./buildconf.sh"
    end
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    system "./configure", "--with-gnutls",
                          "--with-icu=#{icu4c.opt_prefix}",
                          "--with-xml2",
                          "--with-xslt",
                          *std_configure_args
    system "make", "install"

    # Replace dependencies' cellar paths, which can break build for dependents
    # (like `metaproxy` and `zebra`) after a dependency is version/revision bumped
    inreplace bin/"yaz-config" do |s|
      s.gsub! Formula["gnutls"].prefix.realpath, Formula["gnutls"].opt_prefix
      s.gsub! icu4c.prefix.realpath, icu4c.opt_prefix
    end
    unless OS.mac?
      inreplace [bin/"yaz-config", lib/"pkgconfig/yaz.pc"] do |s|
        s.gsub! Formula["libxslt"].prefix.realpath, Formula["libxslt"].opt_prefix
      end
    end
  end

  test do
    # This test converts between MARC8, an obscure mostly-obsolete library
    # text encoding supported by yaz-iconv, and UTF8.
    marc8file = testpath/"marc8.txt"
    marc8file.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    result = shell_output("#{bin}/yaz-iconv -f marc8 -t utf8 #{marc8file}")
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result

    # Test ICU support by running yaz-icu with the example icu_chain
    # from its man page.
    configfile = testpath/"icu-chain.xml"
    configfile.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <icu_chain locale="en">
        <transform rule="[:Control:] Any-Remove"/>
        <tokenize rule="w"/>
        <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove"/>
        <transliterate rule="xy > z;"/>
        <display/>
        <casemap rule="l"/>
      </icu_chain>
    XML

    inputfile = testpath/"icu-test.txt"
    inputfile.write "yaz-ICU	xy!"

    expectedresult = <<~EOS
      1 1 'yaz' 'yaz'
      2 1 '' ''
      3 1 'icuz' 'ICUz'
      4 1 '' ''
    EOS

    result = shell_output("#{bin}/yaz-icu -c #{configfile} #{inputfile}")
    assert_equal expectedresult, result
  end
end