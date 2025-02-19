class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250216.0.tar.gz"
  version "p6.1.20250216.0"
  sha256 "189351ccda100ddfea793bd4a22ab11d1f94182530b1db2376c0d44a0db7880e"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4e742b4cc84065cc6ff7baa009fbec45f1665326a1257328ba6b5f8107e7d19"
    sha256 cellar: :any,                 arm64_sonoma:  "84517e89d48b2a5b67a453e159e77383a3b48ca0f4291e310fd2b76400005ea0"
    sha256 cellar: :any,                 arm64_ventura: "a83524d31e9cbf8017358b0ce53a4a27b79ec9b73fc4bf8f652758e832f0e787"
    sha256 cellar: :any,                 sonoma:        "857fb56f4fc48457a7e777a9a23bab04b4e9a1b8e1cff8b8b4bda6e6ea686cc9"
    sha256 cellar: :any,                 ventura:       "7ee0c834a3570ec25b3afd27090024e4fbff9c94ab20bb76f2bcfd4ec7fd99c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60e403cacc1f1d9bdadb9db619d52c51f2a643781689c29cb863d04ca708624e"
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