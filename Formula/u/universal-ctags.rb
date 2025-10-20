class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251019.0.tar.gz"
  version "p6.2.20251019.0"
  sha256 "55eb273988fefc8208141da587afa9bfe41520b1b62dd92537d0de9441d77d28"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e07fef76f1cf321ee56a84047a7c6dd31ff33e7a50b7c0e2aa93ced0c0b94d9"
    sha256 cellar: :any,                 arm64_sequoia: "34d822b32bd305aaaaefe26fb6be29aa3a323e58804c6b9145b1e9e03118f44c"
    sha256 cellar: :any,                 arm64_sonoma:  "e58276316fb81fd6768c805cb66e5be1b2735afd7188310208483589e0390557"
    sha256 cellar: :any,                 sonoma:        "76045d46cb9abda853fcc989e8e5904d93af3bc18c0f4c92a9e44166721a6576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a3607fd1b5f88243556f240ce18fdeadc21d3daedb4ae835f1f1f68523a2b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "145e0bde751d7740ebddd1dceb302a6e593859bfe916d12cea9c4ae35b33dbf9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end