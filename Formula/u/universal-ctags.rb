class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.2.20250615.0.tar.gz"
  version "p6.2.20250615.0"
  sha256 "34a5ab1a05353de2712dd8479d959cd4ec21b0f39c400731e53ecd192d2770fc"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08bc5c0af7415c63ef93fb30c4da9e68c91647e5595bd3948fc0fc76a24805bb"
    sha256 cellar: :any,                 arm64_sonoma:  "c6d2f38d18cc445f1b734b2363b1cc28463bbb3c9f96f99bb8dc613e214ba1cf"
    sha256 cellar: :any,                 arm64_ventura: "6d92c872ec6764f9e622384befe3f592f5f9e394c1cd087e657193e6146c8f17"
    sha256 cellar: :any,                 sonoma:        "4c95b4115691c35505945addc628e94fff6142582c88f7a72c0c27dcbb187a14"
    sha256 cellar: :any,                 ventura:       "9d7ec0296e489251874f6ac892db048d8e7b61b668ccf4967144fa629d360e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb348f44cbd2a9af78dbb62c674aa30e421e098198a79ad7e45e7ef5eb0b0621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9875831655ce8520eb0a293b5690b01bb5153716fdd574b84eb253c3c9dd16ea"
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