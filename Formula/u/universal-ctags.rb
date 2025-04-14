class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250413.0.tar.gz"
  version "p6.1.20250413.0"
  sha256 "973652e4dce7f6cd6afa207e9d378e408499b9a1a7a8286c660d1750fd1046ee"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4faf86204bb98454a0478cae389e0dc6db0e655a9276d20ddf29fc3173fb8d1e"
    sha256 cellar: :any,                 arm64_sonoma:  "013c1b803a36f605116c0619843c20738085cfe1a4c9734d9106110a2d189727"
    sha256 cellar: :any,                 arm64_ventura: "ae539949c5a4b8210692d8aa7af3ca18f6d90079cd6a8191b4d56896ac08c9a0"
    sha256 cellar: :any,                 sonoma:        "77fb173bb3b80ffb441b5a7b1f7b3f6f03a31ded1c66c751209180df41b65860"
    sha256 cellar: :any,                 ventura:       "c47528aafd61c39dd89a26fbd85f51049f664d9dece2cd5475240f9cd4db066c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7afd9405b2930d8865d02b7d635a5048e9235f39814a5d49d9a107723c4b4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3ef5df258e6b23b18e39a4e591bb26d823b1aab6f0f8cbbbcb23bd06ff2767b"
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