class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231029.0.tar.gz"
  version "p6.0.20231029.0"
  sha256 "05f7a2fc5400d1c0fec6595e3febb7be789458e3a5efdaacca3558ca27ed71cb"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb221635016daf97421703cc3f5e19375a185e0c9afd049e2c038dacc493d74d"
    sha256 cellar: :any,                 arm64_ventura:  "74f1c741b367524e9197b1a351d664773b35e3abc4c148cac5544b17b54ea926"
    sha256 cellar: :any,                 arm64_monterey: "875c6cf50ef7c0b256e26270efe186939e8b6e6d4574c56e3ce16e973075889d"
    sha256 cellar: :any,                 sonoma:         "ddc04064ee239f0ea0bb1f49b9c0929cf7592276b6da7b576490fb569c418ee6"
    sha256 cellar: :any,                 ventura:        "a1b1b9678d9837a42d06f3b12e85252c9c9b6d97285abaa04500af405825c9eb"
    sha256 cellar: :any,                 monterey:       "0b5e9948377221174234c28b2beaf7d7901ea0ac34dbeb0e027449f57995cf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "175eeef700b6ff8c28a0d3c32920b40c76425d817c71ef062fa0d60b58c5e144"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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