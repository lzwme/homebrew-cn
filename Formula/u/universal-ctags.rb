class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240107.0.tar.gz"
  version "p6.1.20240107.0"
  sha256 "2f7a96ae9f04c85072442198cb0a03071b4362e0e75ba7a8ed911345b7629fa1"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "553b97357bc638430bee71cac9c6fcb77e129a109b4288d83c5aa99eadd55413"
    sha256 cellar: :any,                 arm64_ventura:  "4da4539fda465ffa09620583f738bec52de0755217436abcd23e5150e296ea07"
    sha256 cellar: :any,                 arm64_monterey: "f932b6808548c2f9189d7b58d3da38f9680e5c6f3ed7b032799efc3599f6caa4"
    sha256 cellar: :any,                 sonoma:         "b3beb46b14243314c7a18f149ecd28fad9d0b89355f8ba5dcb5bd1e8786ba020"
    sha256 cellar: :any,                 ventura:        "57a18a1f67de0750fcd0ad3d5d79cec915bfbb08fcbbc6cdeee6ed41578b78b7"
    sha256 cellar: :any,                 monterey:       "00621c0a0d9a897bc0b5100e0370f00c886f13c1da889803bea3e089458f5507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d1c1de89301762587834fa457f10ef3380fb726ac79b5dce7e7ae7265b9376"
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