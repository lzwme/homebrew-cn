class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.2.20250608.0.tar.gz"
  version "p6.2.20250608.0"
  sha256 "de01848e246ab08d82f9d330700cbf75ff065b3e0678bfde2df891d3b9648b05"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49c3afdad7e1bfe4f3975453eb4976c5b9ad431395955e02251c93a1981087dd"
    sha256 cellar: :any,                 arm64_sonoma:  "84a8070276028b500bf0e004f391eb5b05d14283fc87e773b90a721b107af7e7"
    sha256 cellar: :any,                 arm64_ventura: "f47b018307706acbee0390d7bd8e97d67858fb4027c8e400f9f1ad4ad0f62964"
    sha256 cellar: :any,                 sonoma:        "34c787e66cce2fc2655fd4ad85b90eda8db909f3f7ef7383cfc433c7df9ae99d"
    sha256 cellar: :any,                 ventura:       "8f7e06cc29a82e4cc1d5690e3997a6c66a6aa50c941d8c434f68f1418cdb5be2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1fe08679684d04d64e6ccca4660c55c0c96569ba2566c0f363f2f17b76b2cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf30781168a2c8542294eda84db49cbfd5cb64983c007ea749e3c54feb96dff"
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