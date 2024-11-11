class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241110.0.tar.gz"
  version "p6.1.20241110.0"
  sha256 "75ea568296fe503a186c932d14c73225aed6f994a6cd5730dbcbb9337cef6b4c"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8258f2ef21cdc4fcb6b4ee493999fb44d221a7bb72bae168341bf37dd789d9cd"
    sha256 cellar: :any,                 arm64_sonoma:  "654f3d0f01f2e2a1a41efcdd6d8e08eeaeb0120056dd5440b6067400e22fd76a"
    sha256 cellar: :any,                 arm64_ventura: "59a633a74582b238937033d2f92b27e4b0fcc5a3adcc0b0637f4ea62e34a87cf"
    sha256 cellar: :any,                 sonoma:        "481de5147bdef18519fce18333dc81427a45453eb44c84cf00b62f9ef5fc69f0"
    sha256 cellar: :any,                 ventura:       "63c02f613ba0ed1549992fe08870604807f6713d6186017d379d67c3b64cadbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e730e841819d0461d90fda63e5bf9832ba6e8f5126f33dea2106ff2ab9fec4c"
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
    (testpath"test.c").write <<~C
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
    C
    system bin"ctags", "-R", "."
    assert_match(func.*test\.c, File.read("tags"))
  end
end