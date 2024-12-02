class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241201.0.tar.gz"
  version "p6.1.20241201.0"
  sha256 "389bd5ac6c9ce93b3644e7660d0f240ccfc27ae54721310df9177ec05b84b3ae"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12f44e7d8ac3f766d7e5d1d3f2fbc6982cdb7b753faafd733d02a835d774b03d"
    sha256 cellar: :any,                 arm64_sonoma:  "85bda9e5274b35e1106917ec542d4774fe3c0a13d52fbd1caa142e4b8e04fffe"
    sha256 cellar: :any,                 arm64_ventura: "4dc76d3134dfdbd4fa2cfb214708098af3b7e2629c9c051d7c964c9269900ac6"
    sha256 cellar: :any,                 sonoma:        "9b39233a90903d7880da13ccf6a163e154ec66ced6fcf20309fcadcebdda229d"
    sha256 cellar: :any,                 ventura:       "3259a55bccf882493a36dc4045e24b058b5ccf2c99fdac045b6c06dc86edab2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546d448f07628b85abd321d83745ede2e6eb227a705e4eb92a13298c307bde1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
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
    (testpath"test.c").write <<~C
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
    C
    system bin"ctags", "-R", "."
    assert_match(func.*test\.c, File.read("tags"))
  end
end