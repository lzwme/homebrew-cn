class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230326.0.tar.gz"
  version "p6.0.20230326.0"
  sha256 "cf379bbc7a16d3b030d483edf7432505e15b998ff4473a41bff66bbc1aa0c7ef"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3847f71b55643133a9876f42250be02a0fd3e93f6d2039082096531d2fb246b"
    sha256 cellar: :any,                 arm64_monterey: "cfba8a62061e4b21b2513ae98732f86350477e19feb2a6ad0894ee75163b8797"
    sha256 cellar: :any,                 arm64_big_sur:  "c38a47905e95c3db7afcb4059b6bad101c16f1674f085d9287dc773eaf9cdf39"
    sha256 cellar: :any,                 ventura:        "3c9fdfa151da9a5090f3c8141c1394e500585670a8d4b6596d78af741544eb78"
    sha256 cellar: :any,                 monterey:       "d9c395cfce9d17ac932144906a02aa37d39dc04801b5d318f1d6435d3b2a0a37"
    sha256 cellar: :any,                 big_sur:        "3f3389eba3bccbac2e7edbd9e48cd9941f683daa13cbdae0f872fda6b9755e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5346f8c1331dcb1d8567e6c5462a06435bce86f03ceaa22ad3f396e8a2738c3"
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