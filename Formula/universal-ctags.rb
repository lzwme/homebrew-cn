class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230402.0.tar.gz"
  version "p6.0.20230402.0"
  sha256 "3c31362c75e993029e4d801803fdecef132bd5157715bfa0c7681e4cef459455"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cbba16b4371367eb67c5412a8eeeb16524a30c85200db4162c1962678b7aea2e"
    sha256 cellar: :any,                 arm64_monterey: "433aa4eaac3075f326a5f19d7c2965eb838bfa47efa827f91c967fe59c9acb40"
    sha256 cellar: :any,                 arm64_big_sur:  "913dcb41613686fb200d17f134b4fa486bda7547209633b0ae2c9e275c26e2a3"
    sha256 cellar: :any,                 ventura:        "407cab6ba8a4810fd4c91a09e96a1d87a59b411e113c18cc553efe27c771a025"
    sha256 cellar: :any,                 monterey:       "144babea9e628b883bf66eec1873a21ba4e6b469167d7eadcb76fc494fe85ef7"
    sha256 cellar: :any,                 big_sur:        "e6eabdb87443ac325321c052ade77a3561ce8c452fed5a370ea40193d48f8ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ab177cce2ac5c82efb8d68fb46e6154a189b252bbe0fc72624338157b7321d"
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