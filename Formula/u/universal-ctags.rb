class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250302.0.tar.gz"
  version "p6.1.20250302.0"
  sha256 "814f8273f811a3e386cbb9409a5ec6e90ebd2d0115a19589c0c23759621f4bc5"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3a3924e4bc26d740d1c29af1624569fea934f160a56190ec1a03ff9897d4d1a"
    sha256 cellar: :any,                 arm64_sonoma:  "2aa9a0145b78fb557cd0caf69baf887208759e68896f1fc93a6f07af9a1a612b"
    sha256 cellar: :any,                 arm64_ventura: "3e5bef6878a8fa5177dee790f3ab7c6f4e981969dc7de7359b6139c1f4bed0c1"
    sha256 cellar: :any,                 sonoma:        "400a3a279a8b2b2446a0ff56bb4e0e12db0a14367b0660bd74f28c0d8a127b1d"
    sha256 cellar: :any,                 ventura:       "9d33cdaebaa982e25e5314fa3226123e720f64dc6dc85b6dd638bbfd549bd942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d70e1a4ea6f1fda7b9e282e5d161c75369409951ec7e31dbae1b5f0b0d7df9b"
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