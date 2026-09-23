class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://ghfast.top/https://github.com/libexpat/libexpat/releases/download/R_2_8_5/expat-2.8.5.tar.xz"
  sha256 "1e727b8933ec51a77a9a9d9afcf8e688bce45d907c13e36ab7393fe36e703182"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2f7a9adce701466bdeb42f23864df95ceef8e764b794c85c07df68ba9be56fc2"
    sha256 cellar: :any, arm64_tahoe:       "f633df54726b7ead09ce36fc26965b3afb702a17a1d540c20962e7e5990353df"
    sha256 cellar: :any, arm64_sequoia:     "3b753370ff9b266e2d342ec3d1d80ed6e1898be7dab45e1d4a0ab54664510f13"
    sha256 cellar: :any, arm64_linux:       "c27c08daba1f44b1c2d616b08d10aa2808bd1e790b21ef03a633768cd06c7c02"
    sha256 cellar: :any, x86_64_linux:      "3d09678bd4ef2f76d91a1381618285d8b581e38298810537260bd9110f2868b0"
  end

  head do
    url "https://github.com/libexpat/libexpat.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook2x" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  deny_network_access!

  def install
    if build.head?
      cd "expat"
      system "./buildconf.sh"
      args = ["--with-docbook"]
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
        static const char str[] = "<str>Hello, world!</str>";
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
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end