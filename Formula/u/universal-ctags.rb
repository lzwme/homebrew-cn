class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240707.0.tar.gz"
  version "p6.1.20240707.0"
  sha256 "534a0683c084640179a6c03bcd317e385108727ef4be243ced0e555884714192"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30f457fd0602033722f401e662f6ef678dd6aacc43ca38acd2c4830f06a258e1"
    sha256 cellar: :any,                 arm64_ventura:  "e94d90df201e7b4c6c75babc9fc861fc944c99daff4cba2d80be5d91264af6e7"
    sha256 cellar: :any,                 arm64_monterey: "3f7b143398dfee864411816b6c3b47d1eecaa333d075a7fddf7a8a0c938aef0f"
    sha256 cellar: :any,                 sonoma:         "3c42fd067b60923fac4635ce700da516c4d815a09722444c9839e6768adeeef5"
    sha256 cellar: :any,                 ventura:        "52f71e79e4e4afd869f2319876a7894598aa79b8a865ff6bd355a536a3074952"
    sha256 cellar: :any,                 monterey:       "becea0e8f173379d70e491ab119572772f20dec4e5c8d08df2cf1e5068c16bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f46d7a2fa1843a88fb3c1786f6edeb30a0afc62500fbcc35f3949378724388b"
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