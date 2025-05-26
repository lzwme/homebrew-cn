class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250525.0.tar.gz"
  version "p6.1.20250525.0"
  sha256 "30008af6bbccbebef82a01712b315cffc70aba217e49fb61f5ed0951ccaf41ca"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "682b807236a949abc7d6b8dd7ad64a2eb26b826f7a7488d3ee8d573901b8bbbe"
    sha256 cellar: :any,                 arm64_sonoma:  "d02a652de4bdeab3c46ffec9d012cf3a2b5eb81a1289b6072e9fc1bf40722634"
    sha256 cellar: :any,                 arm64_ventura: "6f4378bc10c3837f6996d376ff05c54f09b584c5df1e558014bac18e320ac2a0"
    sha256 cellar: :any,                 sonoma:        "bd28475ce56e52d63e84c8216b1980818a490d9c9b92eb527e75358adf020540"
    sha256 cellar: :any,                 ventura:       "2a7385ece264c014a0e2c43b75a563d88d26445559dfd66d674fef597070f061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e8203db6aa4e42fb0a149e23250c4117730992b8df0bed3102ad7fa7764167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e91bd5f4b714622317dd829ca44b670f46638276c92f09f6994db6af3da0b35"
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