class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240825.0.tar.gz"
  version "p6.1.20240825.0"
  sha256 "4ac5f21c138a763ceb00f9cb12f0d420632f155f0a45573ed0f7d98bd516df99"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d9ab3f9beac07fdafce4f3f1ab5540f11d414ee43bdbf70f3f5b6503ff0bad3"
    sha256 cellar: :any,                 arm64_ventura:  "a5c4c9a99c0ee4ed395837c41a7c0a03dbaab5319e3435324ad7b34c0f0ea5d5"
    sha256 cellar: :any,                 arm64_monterey: "bc758678e54e61dfab8a3c7f9fe38d98f7d64a235a846d9514ac016e4d4c0fd8"
    sha256 cellar: :any,                 sonoma:         "9bda3eb2ac5cf74bc139f3bc4763e7d36a0d2e70a66fbd6f6b171e6e0ac40a20"
    sha256 cellar: :any,                 ventura:        "b9da5e1ee18b776e0e210e041e3be956a06e7721ee9ef1c50468d46b64af9ca8"
    sha256 cellar: :any,                 monterey:       "b788f6da951ae7078dd1467f2fb89c61862cdc4ab06efb96752caaf08df64a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd8122bc525672f726259b32cd6665157e0faa199aa8a685b837447093e695c"
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