class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231022.0.tar.gz"
  version "p6.0.20231022.0"
  sha256 "a562d1603bf6f4cbb5300425708bcfdfedbd3b3808ba0ad5ae03247a31508e33"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "31cf05c3a962d0d32afc7b7a3a78e13da6423432e1b733ef835ebe821273cea7"
    sha256 cellar: :any,                 arm64_ventura:  "096bf7d4ca313acb1bb4b30b112641738f026df3426099faba76916494a73aa3"
    sha256 cellar: :any,                 arm64_monterey: "0ce4cd9b2fa57a88dce7f0a6bc669478a641d23d46b663542d8a39b43434ed44"
    sha256 cellar: :any,                 sonoma:         "823ce28c38fc5247727ece05758120a2f81aa69c71e249553a62ef98767c6de4"
    sha256 cellar: :any,                 ventura:        "210b6c0a3296ffdec89addbec59b1cbbf84ab6b72ae120c452611f5835a36839"
    sha256 cellar: :any,                 monterey:       "cc6f951414a54874775c3d4afa78c5705e75f81edff7affe0608fd5f120ee4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf2aa1c25b73bd763e02e6f0b32e873890bc54d97341ae9ab1be68a6796d4b4"
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
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end