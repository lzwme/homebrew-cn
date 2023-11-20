class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231119.0.tar.gz"
  version "p6.0.20231119.0"
  sha256 "5c0b62ad586c8b7456badf3cb2a5d9ed963ac924f0496a145405fffac2548533"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6c0b95957f69e5a2295335306a47ebde2ff7ea9024d53bd321ede585d2e3bc1"
    sha256 cellar: :any,                 arm64_ventura:  "c82c42be6e39d157d52ea51a279f8bfd6b2bccdce777e4fe8794bb37befc2dc5"
    sha256 cellar: :any,                 arm64_monterey: "493e25fb8192b573ea090ba3059c8405ba013fbead0f95a146304d84574de569"
    sha256 cellar: :any,                 sonoma:         "fa6d4c1697c2c5679840a9b43f3e46cb8d3ab02007933336af3831af746801f1"
    sha256 cellar: :any,                 ventura:        "507e6e000f56cbaa408cf59e7b6aeb9839edd3f3ccfb19739b8383ffb2409d8a"
    sha256 cellar: :any,                 monterey:       "a28a487eba6b8fc9163aa2d1f3120efcbf31f41a4a1537649172296cc964a024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975a066245b86d033795fbc9ea40fdadfa76d05e153706afa9050a2da86b36d3"
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