class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230430.0.tar.gz"
  version "p6.0.20230430.0"
  sha256 "92fb0c4f1f93d86115d41f2cfd22791f9db39a7f6485198a0d98e0f2d514f7c9"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5aef04d394c5dbbbfdeb9cdd2193240ca8b2f9fa8964ea81eac1e9586ad3724b"
    sha256 cellar: :any,                 arm64_monterey: "29cd45dd33cdfd3f47eaf30559096f3afab4b00efc1d20fc7025065ee67ee4f6"
    sha256 cellar: :any,                 arm64_big_sur:  "d531bdcd7fa6ed600efa44529dd12a41a922979cccc8300e90aab4228e5fb611"
    sha256 cellar: :any,                 ventura:        "b4acbba764a6a30b78b8bfddaddf8de61bfd841cb1dd8eba5f405b4c60081c2a"
    sha256 cellar: :any,                 monterey:       "1dfeaeaf715e5a67a3bc78ddefeff2bd382d1ac0f67617b934a823cecdfeba83"
    sha256 cellar: :any,                 big_sur:        "2a52d299be4d9f91ea1c3b29f85293bd0e208f84b4403ae5fae7339f39cd8f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "157a157ec49c36c23c52094f21d2e875a047a7b796611cb53505f4e83359ff8b"
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