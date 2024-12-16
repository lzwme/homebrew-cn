class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241215.0.tar.gz"
  version "p6.1.20241215.0"
  sha256 "5e741a69634f79fdf70bd7b39ecab8af4ff6db5450f2858f3fe947bb5ab85b88"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13d820e5ba26d4bae2b3aa0569c539764c16604cdefbd29b42f3edf01600b9b2"
    sha256 cellar: :any,                 arm64_sonoma:  "65fd3b603dfa297a19b689880e014f7be45e519056f1f71304e80acda0207581"
    sha256 cellar: :any,                 arm64_ventura: "5b7a8a8bc14d2426d9aaaad7d45043ba209e6890da25790afbc5d19753c839b6"
    sha256 cellar: :any,                 sonoma:        "716bcc30b9de684223a5d673e29ce06831cdabe003843eb930a60189869400df"
    sha256 cellar: :any,                 ventura:       "b2dcc5e5cde8d834ee91e4fe5294d93e34f32f82ae0adc34052267b2b5357847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "609ea6c3c68433e8731426ba1a4058f96633fc9dca0b16e964a45c9b89cf971a"
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