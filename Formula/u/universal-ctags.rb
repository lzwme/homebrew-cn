class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240922.0.tar.gz"
  version "p6.1.20240922.0"
  sha256 "f3aaaa2f91cc80393dcc6b3268c64fb9d3e002eff35053d88a872178c613231f"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5804091cfe177b15d7d73cab77a6b8d33aa84b511d96803b039da1ca3c01877c"
    sha256 cellar: :any,                 arm64_sonoma:  "6a0b784758d97432a10f0ad933b7a93d6449cfa73ecac6d435c75f51888f2df1"
    sha256 cellar: :any,                 arm64_ventura: "d238604601b4798398820222fe5ff455d799df4a460e5297d6809caab3545579"
    sha256 cellar: :any,                 sonoma:        "19e7df9b8ff312a931f1eccac28a753a4542e757bed439e0f4190f22508b311c"
    sha256 cellar: :any,                 ventura:       "27be7f18ecee2435ef0c3d754382d985ebdd39b978aba68898f64ffbb0479a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee884886daa21da1d8e20b745154554ab68c528a9b3064f5d3022308cd1b5813"
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