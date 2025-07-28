class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250727.0.tar.gz"
  version "p6.2.20250727.0"
  sha256 "5e220083eef20e0c3e6387f281e6663c52059aed0026a61fa619efbf84a3b9c3"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2902915dd5afc99c036de7239e55cfa9a3012334b73df8acab7d53b2171193f"
    sha256 cellar: :any,                 arm64_sonoma:  "65c62c5f57c42b58349c694b9a4396094c97387a3c371936095cc33e793d85ec"
    sha256 cellar: :any,                 arm64_ventura: "a35ee52fe1924b564a9ba3ca428473f11b9ad6e0bb151f5d14457da1a0b98054"
    sha256 cellar: :any,                 sonoma:        "0db7791e41899e03ff3c49ca58fa734e09fa8d3b0e5387ea029a8d9ca1f1b013"
    sha256 cellar: :any,                 ventura:       "afc6d079464fdeaa01468485287983bbd24825d78a881e252ab96a993b20d74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37e2ad1e32875c561bb2b6299c31efd513730182ea4bd59575cfb1347ea120cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42614aac294f7f52a167939570e98088b56c1889d96aeaf0c99c9fddb229c8b8"
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