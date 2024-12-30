class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241229.0.tar.gz"
  version "p6.1.20241229.0"
  sha256 "dadcc1b23e1e9beb8b0654396c6fc1f7e9ef18de112481c3987d3f5b6fdbec8e"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "554128eceb81ec0121ecfa14bab0441218e914f0a9cf7f7c3a464eaadd011676"
    sha256 cellar: :any,                 arm64_sonoma:  "395d4b2b395dc067754d68400c0af80938f9d576c2da83918df8332566e4c7cb"
    sha256 cellar: :any,                 arm64_ventura: "4f74e911c977a55242d09eb7f63553938373f60973dc285cba2cc91f4076cd07"
    sha256 cellar: :any,                 sonoma:        "aa668c72e9410d6df2948500832364561fbcc2e4fef4f53a3147530bfcecf486"
    sha256 cellar: :any,                 ventura:       "4525003a3094943e17c428f311ed36a9027f3700a7063c76f23e4c59aac69e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb8a8d363e74f729923731a5fae6292e091ea7559cfa49f534dbdc527a2c0b1"
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