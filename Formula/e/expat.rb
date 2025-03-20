class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https:libexpat.github.io"
  url "https:github.comlibexpatlibexpatreleasesdownloadR_2_7_0expat-2.7.0.tar.lz"
  sha256 "2e10a6881408b58032cbd20b33faca099e19c3886cb915f6d67da037ca6c43d9"
  license "MIT"

  livecheck do
    url :stable
    regex(^\D*?(\d+(?:[._]\d+)*)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ffe155f8087b1419196ade2a1864c49935e35fefb0d673429490c8b0de73facf"
    sha256 cellar: :any,                 arm64_sonoma:  "760e54bac8cde67ff4c1a794da0b0f0ad2f71e9d0af27d669503af05a619b299"
    sha256 cellar: :any,                 arm64_ventura: "22d09ee4dbf761c226901d06fabd35d8e9a4f15e35f30870aae3fe0f736ca89e"
    sha256 cellar: :any,                 sonoma:        "31c37b7b40448b460e724883603abd254a0f53c1a0c992a5d67c19aed6dbd994"
    sha256 cellar: :any,                 ventura:       "40accb553b0e58b8276951df31b5da6c8dcf09f8db11489b192e3bcead0624c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56d67fea05f002488f0cbd377084b62455f0cb980965ed788568573d81be0a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7316d923371fd99181674bc590ffce24771bb4a3cf5d2377c4f2bb5c199b986a"
  end

  head do
    url "https:github.comlibexpatlibexpat.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook2x" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  def install
    cd "expat" if build.head?
    system "autoreconf", "-fiv" if build.head?
    args = ["--mandir=#{man}"]
    args << "--with-docbook" if build.head?
    system ".configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include "expat.h"

      static void XMLCALL my_StartElementHandler(
        void *userdata,
        const XML_Char *name,
        const XML_Char **atts)
      {
        printf("tag:%s|", name);
      }

      static void XMLCALL my_CharacterDataHandler(
        void *userdata,
        const XML_Char *s,
        int len)
      {
        printf("data:%.*s|", len, s);
      }

      int main()
      {
        static const char str[] = "<str>Hello, world!<str>";
        int result;

        XML_Parser parser = XML_ParserCreate("utf-8");
        XML_SetElementHandler(parser, my_StartElementHandler, NULL);
        XML_SetCharacterDataHandler(parser, my_CharacterDataHandler);
        result = XML_Parse(parser, str, sizeof(str), 1);
        XML_ParserFree(parser);

        return result;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output(".test")
  end
end