class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240121.0.tar.gz"
  version "p6.1.20240121.0"
  sha256 "88f523e6f90ff0cc5a7da6a65b3443d4c6205b515d945ae6e9dba1fa377fe12d"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ba05798a43d9cef5aa20945e1642e8cb355e6b48551445b8b3e04b0acce603a4"
    sha256 cellar: :any,                 arm64_ventura:  "22227711773b13bb6dd3127a5b34875515fd31c712257ec688cace97e9fbadf5"
    sha256 cellar: :any,                 arm64_monterey: "88cac7c82f074d39c1583717aeb988bbf3c99391708f3dbb84cc6f440f0c1c6a"
    sha256 cellar: :any,                 sonoma:         "88c15b8680dd7e4a7d6e92cc9fc0e52c5e05b7451816be3a3e6e611abf8030ca"
    sha256 cellar: :any,                 ventura:        "0537455319970ddde13a69c95c36545b88db7122010d403a33a456806c9a0385"
    sha256 cellar: :any,                 monterey:       "f5d50d63ed06c8c0c21cda1889749ce8c7333479bc287c416b72a97ce6736a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cedf306dcb9791c9afdd0fb20238cc6b315b3eca3a907d2886622e58c55c6e8"
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