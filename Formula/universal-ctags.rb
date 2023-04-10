class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230409.0.tar.gz"
  version "p6.0.20230409.0"
  sha256 "1398d15c79299de51f0f57010ce2062c002da024bdc58344f57d53a836545221"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62cc34b0fb12617e0dec9bf8cc7888ce571112132ddd60ea1b1bb4b6f3bee309"
    sha256 cellar: :any,                 arm64_monterey: "74137e34a9f8532d3fb2d0d8464f28d7574088b245fa50e38656cbc2acd26b45"
    sha256 cellar: :any,                 arm64_big_sur:  "a9b38f27d6b0c5f06ee03a0a793d37a3e9362785117cb8b4d293559a2039f449"
    sha256 cellar: :any,                 ventura:        "03916dab9f22f51c5e640984f60fd683044cab949ff79e7993f12094066fb1d5"
    sha256 cellar: :any,                 monterey:       "b9c60dff2b464c6c51d79138d80a51f3c476388a5b2f41fde29cac31f6e22107"
    sha256 cellar: :any,                 big_sur:        "aaacf8d971baa28d37276901e9876ec6da58ecd9b63af96f42d65aed6bf64d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f24e255d845e4f43fc4eca5c11552ea16102ffda88b24d3cc84d95574b0fc0fc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

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