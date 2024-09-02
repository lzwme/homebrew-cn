class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240901.0.tar.gz"
  version "p6.1.20240901.0"
  sha256 "c264fb16a1093713a69b60e935d6dae2f31b1364aa4bc95c242426e994531870"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b95027a09840d3a08ae2838e6333f19fb4f630feb80d199d87ab139fd98b22c2"
    sha256 cellar: :any,                 arm64_ventura:  "52bc9e1cf65d960ee496c69c3c9f9a12c38d1e7ee420888b1a6f991658e08ba0"
    sha256 cellar: :any,                 arm64_monterey: "4cc1b1df88695575fed0698e270dad79e1b6d0a95c5beb595ac2a087396617fc"
    sha256 cellar: :any,                 sonoma:         "a9ed0ad533a9b4f9e9a78df1d7b841227c1d09b342c120c5baf61d6d9a83e8a5"
    sha256 cellar: :any,                 ventura:        "472f0edac095ccc5538cee074599e75e33417205c118efea83d7ab5f6908f966"
    sha256 cellar: :any,                 monterey:       "73007f95b2026661016df5e92f204e565923920c318807f33e091c0688ef2c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a707df8e366b2e1e71deaa5420e866d0662b09c98fd3060bb713fe3b66f910"
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