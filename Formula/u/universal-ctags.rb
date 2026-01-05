class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20260104.0.tar.gz"
  version "p6.2.20260104.0"
  sha256 "f05b749c4b5c1354f4aae774077800b00fffa9744ca2a29d143270938a3dd6ed"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8acd0014d8cd2bf21942486ecd35a7552280610dc57ee7947b9299b61e5949bf"
    sha256 cellar: :any,                 arm64_sequoia: "647f7bf8a1763cf25fff757ebde3cd88211fd7e8b6c24129081ae10817778461"
    sha256 cellar: :any,                 arm64_sonoma:  "e0fa407f20d32ce5cfad84d938ab6e1baab61136201eb1a837cfebaf17f253a6"
    sha256 cellar: :any,                 sonoma:        "56702f2a661b4133a1a92c5e0a91bc9f90f795f6319eb118adee137b45ec65ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db5a31d32b75d8810e4500e203318a5e2090bb83467d1075097d589ec515fe4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c0b34cf6306f671d0b225f548e21998bae327d0f2752edaa604df10aaa4d598"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end