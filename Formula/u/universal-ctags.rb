class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231203.0.tar.gz"
  version "p6.0.20231203.0"
  sha256 "5b0acd4b0ca81474fbc2246aa7e977bb7c691e5bb2c7d5bc02af11a8e3f73099"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ec88928b75b9d4808ab9ce86c6c79311404eeca84ea0443f4ae9b68674eab43d"
    sha256 cellar: :any,                 arm64_ventura:  "e94338c1779d3a7fb866e9250fb6cbfbb2ec7dc6183077ed3a16bf5878886c78"
    sha256 cellar: :any,                 arm64_monterey: "67f86a523d23682d978c78f8f436344934f8d43bba7d32424f1c2aae8e41c89c"
    sha256 cellar: :any,                 sonoma:         "911817ea9142a0eba4dc427d794b737b41ab37d9a781e22002c341df3b4ece85"
    sha256 cellar: :any,                 ventura:        "f566af3a64b7b67cdc55575579fc433a87d4c65193b3f8cd009b831fe20e0e0d"
    sha256 cellar: :any,                 monterey:       "e14b9c07d6102a9c709e49cda979c16ef5ebdf44c4674c5959e10cd4ef5617f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836f064174303a1148fb1bd0bd4b40487db9ecfedc15deca83822ae72f946651"
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