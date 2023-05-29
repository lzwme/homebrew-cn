class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230528.0.tar.gz"
  version "p6.0.20230528.0"
  sha256 "7fe18c5473bc88086edf84b4057f91c3428fd1000ced2c41bc58864becbba4b8"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5fa136d88d2730053809ac85dabf58f1e2becc3f809df8dc7e1540c9ef8e29fb"
    sha256 cellar: :any,                 arm64_monterey: "8766d2c96fcda36d1f5f9a771e71e20bee06887150ab282052f9853aa288e759"
    sha256 cellar: :any,                 arm64_big_sur:  "69978d7f6b321cbaea369dccd22b6d4df438069d49e50e435296c1ae44345507"
    sha256 cellar: :any,                 ventura:        "a514ac4c47bd2a0eb179b6558181b21b55b2a0b0a665883a033f223c250837ba"
    sha256 cellar: :any,                 monterey:       "1bdfb37bb92a0a5d6e8e147ef2d1fd7a886cf73e563f470ba901d8fc6cfb7441"
    sha256 cellar: :any,                 big_sur:        "46390cd9eb7fe257cd64c23d32bf8a3f67d8d913e98b45253f2bb217629a8823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d0b1d4ded658f11fbf37863b94e12af120ecd3f3e7c3f83224b235211cb410"
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