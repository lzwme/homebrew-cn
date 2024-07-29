class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240728.0.tar.gz"
  version "p6.1.20240728.0"
  sha256 "e3abb73b46cfe6ac28206a475e86a3ff59ef45cbad376ffdba4f44d016c3f58a"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f82ed89ddb17194a87dbc578fea5fae40d69cb3b50b60926bd5250da6510688"
    sha256 cellar: :any,                 arm64_ventura:  "6e9fc690c72e2569c924cfeb6a7a810415b777d005c7a2be6f9d52a87996ed39"
    sha256 cellar: :any,                 arm64_monterey: "43890527e96636e1c22670cd89876ee9c8a10332991134254ae0a8b64829cbde"
    sha256 cellar: :any,                 sonoma:         "86b163f1ce1ca5382aaaad53f4fa966dbd6a3e9bdd7966abcef88bd611f76276"
    sha256 cellar: :any,                 ventura:        "7b41a304f2be3cf713925819b3200620f5df699a21b72a623d6f024d29639f29"
    sha256 cellar: :any,                 monterey:       "46365c26f12ff6b1be24123858f49c139e43124a584da41dba1e89c2f979f3dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f26d32d5ce3ca4098b87543ea0669ed69672b557d1b9868b0a2b88473475adc"
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