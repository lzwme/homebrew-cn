class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240204.0.tar.gz"
  version "p6.1.20240204.0"
  sha256 "00e06ff0c1c91cf6186b6cb05cc43a35232ac7fc5207a7d1060b1ddd823ac1e7"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "86a09ef7d8894915af61ee0d544d141ddd527e774b381bbdf5b252608bcdb5d3"
    sha256 cellar: :any,                 arm64_ventura:  "f3fcc67b9d3103675f39ddfe92e25d735d6381a732de2bb39d1d9cbfd19b437f"
    sha256 cellar: :any,                 arm64_monterey: "042d3339ea0c9ec0890f804b1bd767eb5e9a7bdad818f7e92a518bb48f2954d9"
    sha256 cellar: :any,                 sonoma:         "1007ca6bcd11ba2ac06f598a68ea79f58beda8532028599bf6c9a6f8a74aa722"
    sha256 cellar: :any,                 ventura:        "9404064fb953b178f54a0379dcce8c74da01a8222a53040cd0a0c43c080a77e1"
    sha256 cellar: :any,                 monterey:       "f5178b1f2901db9ad76323e87db69cfa99a06ce758acc661421ac2f832b0e829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ea7a1e7a39b21b6dc9b1612bb88a2009c25512877c8a38bea62aa988d3be03"
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
    system ".autogen.sh"
    system ".configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
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
    system bin"ctags", "-R", "."
    assert_match(func.*test\.c, File.read("tags"))
  end
end