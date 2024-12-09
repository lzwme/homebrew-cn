class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241208.0.tar.gz"
  version "p6.1.20241208.0"
  sha256 "db62d24aa53b4cf1c9abb9ed3e14f3e774761b86eec01aa9edcceef1ace1bf2f"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1950905d1d873904004fdf7ebb64e32e8f0bb488482889b969603cbc7f4d92f2"
    sha256 cellar: :any,                 arm64_sonoma:  "71faf5b7b2c9a9c9b0004b1b04ef53395f2a715b1626cc591400ce7fdb4749f0"
    sha256 cellar: :any,                 arm64_ventura: "2ab3b6c556c61d8441ea13ad003dfba45ca02d428e51ad5fedf61840be0293e9"
    sha256 cellar: :any,                 sonoma:        "5a14b32a956e87ab03cf4a3db20c93ec7428692120ec32f18e29e0636d1da295"
    sha256 cellar: :any,                 ventura:       "7ef3bae07ad78c2799fa22ee65a70a39af47bda1d44501816f0ffb01af197a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706d0367934baa776ee62f2b4fa42b80cb31b32472a5a5658252a72a45c61ed3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
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