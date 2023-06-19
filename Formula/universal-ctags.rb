class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230618.0.tar.gz"
  version "p6.0.20230618.0"
  sha256 "6a5288e814dd441b80fd71984c6be642fb034041ea5db73fb6fb66497fefea91"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "410a8eb1c929ab54c7f524bf9d1137b91732adba4e053610bfbd4391a6419e47"
    sha256 cellar: :any,                 arm64_monterey: "4e1e1b82d529b3d1778764e544230bee261b56088cb80029802387c01591f205"
    sha256 cellar: :any,                 arm64_big_sur:  "b54762112472645214898222d2365aaa209788a7c888bf99973ad38665c539b3"
    sha256 cellar: :any,                 ventura:        "ceeab17f7cab0afff6b5ed99c4967c149f0fd4448c8d327dbf63772daf11c068"
    sha256 cellar: :any,                 monterey:       "1a43c18790ce906aef3cf64f60649798b7f9dbfd2aaf0efd58653983f911eef9"
    sha256 cellar: :any,                 big_sur:        "5ab5ec725863b5f48711c73cfc511852befea43bea5f99a44c1d47c0d47b60d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b762ab19e5466169754ab980387c01b6920cd57f7dc024ea3a828a79afb7147"
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