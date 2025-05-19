class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250518.0.tar.gz"
  version "p6.1.20250518.0"
  sha256 "176e7f2cc0f1751831679f8731c9f54902563df5c99aa2379e218d378338c43e"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22c8316ebe6299432ec77703d66ce132752c07ef8191cb8acc40cd856679b595"
    sha256 cellar: :any,                 arm64_sonoma:  "6142c16a6ec34c6b85f7ad5cbcf4a70f8a71a200fcd4933466485473af92a9bb"
    sha256 cellar: :any,                 arm64_ventura: "f866e8b6937401a078b2183d2825acf3caad8c72b2653001990b04ef589aa92d"
    sha256 cellar: :any,                 sonoma:        "af83ac69fbfe4662783a50c4e1f53f6557d80f4b81e8e04fa7046ee23e0369cb"
    sha256 cellar: :any,                 ventura:       "e00a1cfa3bc12cf0c8f8927638a7356f988aa7d0d66fd5895b7cede7136b08cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7feeb088ab39fb19dcbe34a4ade0784a1bfc8a882d2c5e3376805b23274a503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b8321be1cad433d5264ef587a83a817c3f95aecf9cd9c99def8e49cc7cdd8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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