class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240602.0.tar.gz"
  version "p6.1.20240602.0"
  sha256 "161010cb70a74d93240f0870f66317781325c3d937df6ea18aa9169e1bf17fa0"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97721cb580359b0f3abf9445d45f34d431336f8718862cbff5a2516116642402"
    sha256 cellar: :any,                 arm64_ventura:  "896ea0a5de67199efcafdbe7a37c2faea2d8c68827e2c275239c20f03e7b6ffa"
    sha256 cellar: :any,                 arm64_monterey: "e09672f00cd7c350478b477be29f0b711bd584f95f11b6724a2bc066a14c49c1"
    sha256 cellar: :any,                 sonoma:         "3a4a3d3c17cec8ae279e3443f430f70a62bc8e4978cf6924f57101d1fe8d89e8"
    sha256 cellar: :any,                 ventura:        "63c8f5b04dd929c7cbd84f93fed3526f908681f6646b16990d39236dbd966e65"
    sha256 cellar: :any,                 monterey:       "269b8c8632d23a1a2274fcce6ce0a75e1fda897719945bb36ec1a03b44d52613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613b76b8d290ab14c0e08ccede228013cc91a095f86cee70d488ee6b27384c0a"
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