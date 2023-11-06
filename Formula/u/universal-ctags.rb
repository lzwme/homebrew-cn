class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231105.0.tar.gz"
  version "p6.0.20231105.0"
  sha256 "cb8077924b8f41735598335d769826cd3f4ff039a265ed48cac359fa7185d408"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a1fab1e8594c5c5294a91c3090ca04f41aa944cd7cc926e4212a4236e239010"
    sha256 cellar: :any,                 arm64_ventura:  "fb073be8b607a38766656b2ccec4200d9af6a91f1a60c18eeda06dc34e4d1c39"
    sha256 cellar: :any,                 arm64_monterey: "6d10c0322d1c381a469a451c6811ce8ebbfed10dc2df554d488202e6712bb022"
    sha256 cellar: :any,                 sonoma:         "33941f5c0745291aff13ba5629271b17d09ceaf0c0c87b23a8873aa03ebd3712"
    sha256 cellar: :any,                 ventura:        "2c1cdca99c473c4fea83ed1984dc62c11d2c9b7acd123ea5f3c533e51ae1b617"
    sha256 cellar: :any,                 monterey:       "4036a3f7acaabd5a9d44a8d1f7ec838981a0d8b294cbe8be94dc9b7ea44bf6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa09db976a8ca97ad50cfb3ef09e887c4e70bbf3eacd98c2284f53f7ec4f209a"
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