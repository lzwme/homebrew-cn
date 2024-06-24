class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240623.0.tar.gz"
  version "p6.1.20240623.0"
  sha256 "ad6e17d58805ce5e48b31f99c6b0e758a9457c87e1d33761f4fe052b25d51450"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aff5beedf9bc9365b0eca0db2104103f394fe4b86d75d7f9f75726f2d4443e8d"
    sha256 cellar: :any,                 arm64_ventura:  "6dbebe0d4f4ecfd1326cc27bec8b700789563d80dac6b5971fcd53c5eef1f680"
    sha256 cellar: :any,                 arm64_monterey: "f3e21992c6ebcb3e1e2fe829faa12feda1c48cf3d853a21139e4b7b2fa8cb982"
    sha256 cellar: :any,                 sonoma:         "f9b265ff6ac5782f2dd3797409d60b071e75d79661f0102c01a369d45f0fce58"
    sha256 cellar: :any,                 ventura:        "e6dee6b8344de35405b28f1c9b5717b0fa3afda44ccd5accb57550c44848cee8"
    sha256 cellar: :any,                 monterey:       "28f19b68b69296ef0dcae8d5de979bb2413b9852bea643f7e07d4150986e6fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a34b10b5efa1262b0aa42664500fe05916a65a4bc4fd281061497379571f41"
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