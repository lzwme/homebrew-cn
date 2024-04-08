class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240407.0.tar.gz"
  version "p6.1.20240407.0"
  sha256 "68a76567254d3d9e290c6e1ccbc80292d9ebfe2afc8f1902c898095ef8437973"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ce24628c3f77b6eb9ed732b262a90cc2b6ccc061bc4761b712167ee5c5efddb"
    sha256 cellar: :any,                 arm64_ventura:  "16d281f9cf4eddd317ffb253b3d1c6697b758b88a9a4e69e52d48785df4771df"
    sha256 cellar: :any,                 arm64_monterey: "15a1cce83cf80c277d784831a749f80a5d8f949caa60803c6768303e66480beb"
    sha256 cellar: :any,                 sonoma:         "aee081d18e602b5052a55afd771fc9135febb35c58aad4592cd38893a05145fd"
    sha256 cellar: :any,                 ventura:        "53f3b576a6e21a53e389dc51de3a9fb6f9441f6a1f3727e810dacab17c3495eb"
    sha256 cellar: :any,                 monterey:       "2bd921094c89c79dfb20eb7b5908353d558596ade6f5cfc51c0b72d2c89dc42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bafa5ad4f7ecc9813bfd7e2b769a447fe906d162e10d992c5bba9d926c174ba"
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