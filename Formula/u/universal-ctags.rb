class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250810.0.tar.gz"
  version "p6.2.20250810.0"
  sha256 "5d3c1fdd22d733e2e62d1e302c0428c30f4b156461eccb6a1eefb9deb3803281"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe64a590e8f402c9b1d86bc1c53066508f76a2a71ca9ca040bf95b2a5aa7deb6"
    sha256 cellar: :any,                 arm64_sonoma:  "7fb230e865b2d9ce4b8b926e54ecf699317fca2563b918b3a658aa38fcc4839b"
    sha256 cellar: :any,                 arm64_ventura: "2028c037bb6ff8cffcf104694643bbb5c1c3f2fd3b5b3a676b68b184be74f52b"
    sha256 cellar: :any,                 sonoma:        "c6515ea1d4cb92bba51e31f2b0a3728299233a3bddc91865fe48f448fe4637ca"
    sha256 cellar: :any,                 ventura:       "1902782199795dae438f1e112fc0868a0f6ca3ad2d0d1a743334e82e79dfc7cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6f2efe8e11f0344e1af2f8b38ef44c0de6abb23fa9e1bbd390374e19154143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b15674883b684c97696a64551a03f32112e4a03ebdcd5ebc00221ac75aff8ab"
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