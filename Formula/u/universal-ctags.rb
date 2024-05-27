class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240526.0.tar.gz"
  version "p6.1.20240526.0"
  sha256 "0348ab43090384b6b8203dfc99dc9ba0f0fa9256e869cfd851c6949e0f1cefd4"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e51a8ad084c0bcd24ca0d329858d615fe592a1f99c8589b8216e82bb2d20ce84"
    sha256 cellar: :any,                 arm64_ventura:  "48ab49e9661f8e15189b39d30924f534f76bf334d5fc19a3a87a61e1aee9066d"
    sha256 cellar: :any,                 arm64_monterey: "fd9fad03cafce3d34a789bcce6dc4919c15c00a2eb0275aba779b5dff829d6ed"
    sha256 cellar: :any,                 sonoma:         "f9172e45cd4fb090c0ccc76fb8638bcae23a97e3b10b3440228a9a6953bcc517"
    sha256 cellar: :any,                 ventura:        "c09f80f5e5fbf1594545b3bb82d70c35b71a834db6d3cbfb9d1b78d125e26d69"
    sha256 cellar: :any,                 monterey:       "6e3be5a6727cbb577764cff4676e390bb0317734a1188bc723e8508116de2394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860a17a081cac0476da382082699610e16e40a5da2c824f8d528f96a50806346"
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