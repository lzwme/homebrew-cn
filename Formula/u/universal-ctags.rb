class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241124.0.tar.gz"
  version "p6.1.20241124.0"
  sha256 "37e8abcf0eeca865d63f7f546ad81d66e400ca7f12158fa6f3c611b774aff4df"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02b1d3061c2df28925a81d7b0b08a7a0a6d123688e38160ac8e0fe33f92e6e34"
    sha256 cellar: :any,                 arm64_sonoma:  "f2791ec2fc9c6d4840f515b83267fbc40d035fdf847b8331ee12ae0632f2b9bb"
    sha256 cellar: :any,                 arm64_ventura: "1695e5ebc519d361b3a13045c9e9179daa7a316ff109c6fdd013652d3a770598"
    sha256 cellar: :any,                 sonoma:        "dcb0409d392ea8ecc1c4d3fa4df08cf303ce7540b18e58fcd013b1fee4b26fe0"
    sha256 cellar: :any,                 ventura:       "cc0031fd48216d2108b0b1baec4269f842cd273512c3146dd0d5f0f0769ce694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313db9622ed119c40fa6ea597ded6127898d115d737613824635f0441cf9140a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
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