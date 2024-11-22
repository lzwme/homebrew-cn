class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241117.0.tar.gz"
  version "p6.1.20241117.0"
  sha256 "09d4ae840e02135acccef41901b348378f90cdacd6ea3bd7acd91b45ad2019b4"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b754b33b387a2e874f7d69ebf1a53243b67e88f6eb61abcd810fd5c7d63e93b"
    sha256 cellar: :any,                 arm64_sonoma:  "cc194f7891fda94c0549a47d8087b0b4f908f22c8183e667c4d9749e49828f97"
    sha256 cellar: :any,                 arm64_ventura: "f97fbd90efd30a1488f7650c1347eca7ab47ba36061efc362a60b7fb580f8e4b"
    sha256 cellar: :any,                 sonoma:        "c7fe9d172257e6d9a6eb6fad44b05476ee6e16ab57111ba79396da68f4cb0db9"
    sha256 cellar: :any,                 ventura:       "d3f77b9f181cf97327fc4254d5d3b8e1fa07982301ef35f5bde06079d7b697f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07feacb353d5381d4d58f4f7693180f86271a5a1eb52045d6a1af88a428115a5"
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