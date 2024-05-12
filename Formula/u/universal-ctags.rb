class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240512.0.tar.gz"
  version "p6.1.20240512.0"
  sha256 "f0d2e7b4f4903f3980c7f0fa311018243581ad2550fc5bb75abb6e902874c91a"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b51d9bc6ded3e6a5c75880cdc310afada79117886e636bbeca28534dbae5f63"
    sha256 cellar: :any,                 arm64_ventura:  "8e501cddbaec66a17b07694288d6d4701c9ef2789f4dfcfdd2fd3bb7ce208fac"
    sha256 cellar: :any,                 arm64_monterey: "7272efe1b890cb57526a70704de92557266bcda50bbda3d7d353bff65034cec9"
    sha256 cellar: :any,                 sonoma:         "7b8c008e07e594fe54c7d35efbe6376293d202c7a605597a15cea85c0303022a"
    sha256 cellar: :any,                 ventura:        "a9aa8334707c0d95cf353701df07d2928889ece1f4752025be3f04269c27cd49"
    sha256 cellar: :any,                 monterey:       "411a78ebb825c0fc2502077cafb4a7b8363567b2f0c40df05242a8e002f68f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea78dee59bcf494f0dcc47b87eb796f5cd95dfbfacd941782448453e8da3c08"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system ".autogen.sh"
    system ".configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin"ctags", "-R", "."
    assert_match(func.*test\.c, File.read("tags"))
  end
end