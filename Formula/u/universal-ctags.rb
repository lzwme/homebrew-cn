class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231210.0.tar.gz"
  version "p6.0.20231210.0"
  sha256 "15d2fd73d23a1a44c5c1524cdbb1323a6f2f4848a3d1a7968a291e1a3b7603e9"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bdb4e9b2ece9ffa773e7d77583b9aafbdd8a64deabe94e59b25ba2867561d916"
    sha256 cellar: :any,                 arm64_ventura:  "5d2d106ab391b6fcea088ef0e714640284edf3c75b2219aa40edbc092d2acf8a"
    sha256 cellar: :any,                 arm64_monterey: "a8e338757115f4eb7fb4409e7f84ecca19fc4296d70fc33faa318299d538cf97"
    sha256 cellar: :any,                 sonoma:         "f8fc4b54dc393587a6e4dea73b431c15c02b2a057666d97ab926eb3340f02794"
    sha256 cellar: :any,                 ventura:        "2358ad15aef375fe62ca2fbef067746561f593f50ffd97e11cb73f8931d9c069"
    sha256 cellar: :any,                 monterey:       "5c0cd1f8ccdf59cd82c20e03823fe1d7e24cb63d8532fd865afff90d21ee8f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4808ec5550784fd7e71776c1ab60390b2e74e22a5e41ce8c84e54fdf97a8cd6"
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