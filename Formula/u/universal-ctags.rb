class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250112.0.tar.gz"
  version "p6.1.20250112.0"
  sha256 "616ce4e7c0c90464fdd8224b890535af0636f22b639890d725149fa4d17103eb"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "edb44100da8b05b2186f42ea526af8f41e1cc4efd453e6dab567b1255adde5db"
    sha256 cellar: :any,                 arm64_sonoma:  "b6fc534d15d39e6baffc5b8af83ef4e8564ec4728a31a87e5636d5a98045507d"
    sha256 cellar: :any,                 arm64_ventura: "976759c968afe021512577a7979b13e4d7b853984c33c43c713d0b804efdaad7"
    sha256 cellar: :any,                 sonoma:        "2469c648116cd16e58eae1c509f5862815eb3f340ff1842909f17ba38386e2be"
    sha256 cellar: :any,                 ventura:       "9db4ca84cd176054b54e5fa4ef771421177499b8928f9439c5b9ef7e74d40895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fc16caaebb96fa824e3956bd4dbe0be4173147d5952f39d7492e9a6d7e6810"
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