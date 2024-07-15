class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240714.0.tar.gz"
  version "p6.1.20240714.0"
  sha256 "68c214b3cb7e730499d33f5709af816f5cb62d554807380dc14ddd677eee437d"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "527fce63b930cabab18fb6742344986a5d79950d510c6f98247fc8110fb36440"
    sha256 cellar: :any,                 arm64_ventura:  "661f1d9b8fcdaff04e36721c531cc28e809605752f8276a3725e561718c4d70e"
    sha256 cellar: :any,                 arm64_monterey: "fc1677a434fc00c0cc2bf27aba7d80e11e7188451eb6278063978a2eac53004a"
    sha256 cellar: :any,                 sonoma:         "b9c85dd32f215fe85a9b533a67ad7e4abf86af2c7c4837560ebcd81a8b538ee6"
    sha256 cellar: :any,                 ventura:        "a5d736808adf8e5966ed7462bf724ff69eba624f0f0ca205b86e515553cfd35b"
    sha256 cellar: :any,                 monterey:       "a2fc0e0cf46848869a7f2a79beb12ee2600dd5fe54dd5fbb11f2997cb02b8b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc2c1476b7b7303674ab2cc82abbe06f9bddcdb4d2a0a9d641abca7c74daee0"
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