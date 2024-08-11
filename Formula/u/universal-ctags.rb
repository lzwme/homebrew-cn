class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240811.0.tar.gz"
  version "p6.1.20240811.0"
  sha256 "55ae91e2f720896d81e2df6f49f10c166a38b89b84dfb86efdda6eee75557f5b"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5641d8f1a93f3c6e443a2d70dcf719d8eba1aef5c59517f3b95cb40cdc9e6644"
    sha256 cellar: :any,                 arm64_ventura:  "68681e7c79d113a60c89e081255e5080e04c1b6058e30e9aa9b65e962e5fcaa0"
    sha256 cellar: :any,                 arm64_monterey: "28824b9fe1aea79047ba8150930e90c50e37e349068da79dbcfc19b4afee84d8"
    sha256 cellar: :any,                 sonoma:         "9439cc9dd525ab9764c36914b194c755f0324767254698b4c487a4a45f2fa58c"
    sha256 cellar: :any,                 ventura:        "ad0f709a2065e28b365df321a76ae28453380ca9253bec24a261bca7583390b1"
    sha256 cellar: :any,                 monterey:       "b829a3f0d8aa4991d82fe0376a30730b612f0beccb17f650bca9a5f3735d82be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d43c5013c3331533134e43479867413bca956c3c061aee5dc8fea6b3bfe28a0"
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