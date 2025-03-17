class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250316.0.tar.gz"
  version "p6.1.20250316.0"
  sha256 "d8b86961c621781be5293d8204f8efce152b71fd8e49b3e8cd882de48d74b02e"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c09427cb42737ab5d6002ff01f4858564e441ca7027ca8401f40b28278400da9"
    sha256 cellar: :any,                 arm64_sonoma:  "b9043ed04bfceeacc42c030205b70d4afbdcd70bdab2e0a50164bba10da7e4da"
    sha256 cellar: :any,                 arm64_ventura: "36ac331a645a92a4d11c095dbf9da2614a9a3193f11e5ecda7ce44babe414a13"
    sha256 cellar: :any,                 sonoma:        "1235f0be3b3da53145595db373e706c7bec716bfc85c300d4d2f712d60dd089a"
    sha256 cellar: :any,                 ventura:       "ab36ea8c5223a69e64e4eaaa4f68359ffb2bdc1fa6495e41356232e79edd75d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90c5bc7cf12d8359b5bf2bfaa2e0be26d3ddc1d814afca9018e8b48158ac6520"
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