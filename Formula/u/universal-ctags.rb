class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241222.0.tar.gz"
  version "p6.1.20241222.0"
  sha256 "fa41cf1ca32178c86dd305b70a956ea5fd98fcc459f3d88a9350c4bdef505808"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69954b6c257abf2c4aef0961af87f2f4e5a4eb371e9e22c5ca8a96de946d9cf8"
    sha256 cellar: :any,                 arm64_sonoma:  "a7c10f6d2aff1566293108c2a9242d2b42ea578ee838d7c616f3f9090a8e2aea"
    sha256 cellar: :any,                 arm64_ventura: "15793be2ad915378a72bd5d94c198fc6eece8f335db42a07fb4844b009d8e7de"
    sha256 cellar: :any,                 sonoma:        "6f3187708cd59cbf0b339dace6b48f96b3484c4561fc2b1d6bfc78690716e69f"
    sha256 cellar: :any,                 ventura:       "e5f4bc898ed78a0278729b6cf54b9cb96126b9b2ec7b05295e182cb90cfa14d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23130fd7cd4172c271ef27eb1323842f97452ed2340518741b4eff74504aa76"
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