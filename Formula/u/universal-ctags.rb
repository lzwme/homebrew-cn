class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250330.0.tar.gz"
  version "p6.1.20250330.0"
  sha256 "11003d66de23e91add9059da2f82ddf2193834839d00300bb676927357b4d837"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2efd6937534f941d21f6d19eb7141441ff1ebff179536fa3d2f851a186f10ae1"
    sha256 cellar: :any,                 arm64_sonoma:  "f4e133dc25f456dbc64778f02b8d48ed97266ef77fbb2a8dc13359efc4bf2de8"
    sha256 cellar: :any,                 arm64_ventura: "aa331f7e4f1ca9b81999ce8a62df29d14f9e5b2522c58825312e45e24919e5ae"
    sha256 cellar: :any,                 sonoma:        "14076bec25e86db27c38d2cae8f3bbd20ee8d8494a45993b1ac5c0fe74fe209c"
    sha256 cellar: :any,                 ventura:       "4df5b45619ef33f550afa6e16caafb96c4eb477ca58fc2676fa11b7cf575d067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fd339b81603f8864889689c2c9aad3edfd0322c149bc62b9bfb3dcb1e24e952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1eb1a50813d112ac68a435ee18b8bbc39457def38624a35ac1cd98d2c29b1a"
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