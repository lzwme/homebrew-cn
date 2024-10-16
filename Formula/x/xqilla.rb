class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.4.tar.gz"
  sha256 "292631791631fe2e7eb9727377335063a48f12611d641d0296697e0c075902eb"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/XQilla[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83e21758a4570293176969d68d027817a4cabbda27702a1f17df9d21256ef45d"
    sha256 cellar: :any,                 arm64_sonoma:  "d010a25cbbc379829f8782fe13daab681386d79611ba03db8f6be10d5a592a52"
    sha256 cellar: :any,                 arm64_ventura: "f84208fd263e7d62474d60496b0476bd1b6cd11c79192353a32cfb6561fc0e90"
    sha256 cellar: :any,                 sonoma:        "a7f37c4ddffd21e21c56b485ae2cb8be6b7e67c994299f44cf9f0ad8220ac464"
    sha256 cellar: :any,                 ventura:       "b06f8a2ebcdddce0def3f89ab47d8c76667e79aaca0768501c0fb4f6ef43fdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb7468c61618269082f2d77bb318e021fac14df13e818019fb1ea4e87cef35d"
  end

  depends_on "xerces-c"

  conflicts_with "zorba", because: "both supply `xqc.h`"

  def install
    ENV.cxx11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-xerces=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <xqilla/xqilla-simple.hpp>

      int main(int argc, char *argv[]) {
        XQilla xqilla;
        AutoDelete<XQQuery> query(xqilla.parse(X("1 to 100")));
        AutoDelete<DynamicContext> context(query->createDynamicContext());
        Result result = query->execute(context);
        Item::Ptr item;
        while(item == result->next(context)) {
          std::cout << UTF8(item->asString(context)) << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", testpath/"test",
                    "-I#{include}", "-I#{Formula["xerces-c"].opt_include}",
                    "-L#{lib}", "-lxqilla",
                    "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    system testpath/"test"
  end
end