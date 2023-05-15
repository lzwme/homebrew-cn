class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230514.0.tar.gz"
  version "p6.0.20230514.0"
  sha256 "67349c5ddf629d4355f9ce9681590c1eebcf043b2c840ff27332b052df48cb3f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d4d9a07b608d8e70931434c7c8178d79f5dd8f4aab3c098ed5f36e579264d6f"
    sha256 cellar: :any,                 arm64_monterey: "558283dbfde7f3c194f715e14e4ad776807e103ceb4ce662ca8e628a375cdddd"
    sha256 cellar: :any,                 arm64_big_sur:  "c99bf57b6e228faf1bd4e4154a69200043bb2399a33ac0335f5c1f0ba12ee6d4"
    sha256 cellar: :any,                 ventura:        "c7431e6277e424a9d901c3a9deec6586a63ab6cee32de8de942fdfc293e99b63"
    sha256 cellar: :any,                 monterey:       "f319d95b90dd0ac0e00f960874a6b975c453ec5ea34b97a1c5d3baa35ce10353"
    sha256 cellar: :any,                 big_sur:        "a6e3cc1d2b34e9167c65182304dfe222c36ecd7fef4da1ccd132f9616f76792c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae209e9865b576250b3a68016ce746b50588b15fe51a0d30aad1c7336beec663"
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