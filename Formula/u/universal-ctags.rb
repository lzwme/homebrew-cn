class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250223.0.tar.gz"
  version "p6.1.20250223.0"
  sha256 "0211b7380cc53eb05506205242b0e80357f7a9295ac7d489f43b15a14b7609dc"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41cfec60969bd58da17d5724d2a0a6dd4c4955bb099cd25d7d54c8879f3f13b4"
    sha256 cellar: :any,                 arm64_sonoma:  "27987c8251db4c8942bda4850645f0803b15d94a92b839519719688f3859ac4d"
    sha256 cellar: :any,                 arm64_ventura: "2f8f33778c767f04000865cd36a1242196521a7811c1631df213da32e46a58cc"
    sha256 cellar: :any,                 sonoma:        "659a4a69e91c2461b1e05a1cbffd53568e7498a312d9920270d6ac60d4611c8a"
    sha256 cellar: :any,                 ventura:       "2f32e97d82e8dc280ac17d7f9331036c8ee1ef10ebfb1b1b218d0dae148777f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d022ae588377f199cc75432bd5b19ac5ecf1fb07e14dec5ac2520cb56aaa0f98"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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