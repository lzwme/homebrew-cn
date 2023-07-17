class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230716.0.tar.gz"
  version "p6.0.20230716.0"
  sha256 "69fc7095e6a9a29607e8825a56df79c64e8875cc4fd3d0ef44781f27bbb85488"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1a8a92591325564f260dff78a0fa346905563741862ad502c4c359c4789a65b"
    sha256 cellar: :any,                 arm64_monterey: "85db41d861b58d5f8354c1269ec4e2d6a3712f29f7420e349e4201f3fcb6f554"
    sha256 cellar: :any,                 arm64_big_sur:  "1a4d013722c7d19461cba374a55787e8b498387fe1299c529e3a8a00bb3afa1b"
    sha256 cellar: :any,                 ventura:        "0995fb3360b806583c9aeff54e34f06e8391ca46d431dce9ca7d368c65a70b9f"
    sha256 cellar: :any,                 monterey:       "8d1c51dffa2fbccde9a80b63161cd4e6a7b7d855b24172444d14b93fad98d811"
    sha256 cellar: :any,                 big_sur:        "1daa79d66972ef5bb3248f89ffaeb4eac89c4004fd1c85c5337687ba5b9f38c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f45c264a52ad096d9001dd3fa4e676e86ddfa76d4bf54a443d0fc22bb932e1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
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