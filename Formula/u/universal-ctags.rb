class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240128.0.tar.gz"
  version "p6.1.20240128.0"
  sha256 "b4375c66b66616eb0bbf138aafa203e3ed89350d1c5ed3b01c68ac43fc6d9a46"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2bc273d877fe9a3d491246c97444741f3cb997a365fc2c4bdc8d22e102f6c54"
    sha256 cellar: :any,                 arm64_ventura:  "1fd99f301cb5f9d00da2145302fc48e1be3cf74a4e8929104dfe9f3487818f14"
    sha256 cellar: :any,                 arm64_monterey: "cde9312f8c865ea30e4dcfe2b6eaf3b65bf845af5b50dfd30732665b0a8b08a4"
    sha256 cellar: :any,                 sonoma:         "c26d2d1a0e9f9f9c370831a0a196c7f77bf6099eeb7aab4506574b63c1e940f2"
    sha256 cellar: :any,                 ventura:        "436da48b5c13a474b3880e221bec838dd21a77be273640e1c4370998923ab117"
    sha256 cellar: :any,                 monterey:       "8e0264c97d48c44ebfc489ecc493ccbf6842c1a5af7cd99a09f6a4a8acaa1c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5510ae890940c24c77d8ff5343cf5112f98d9e4ad2ee477db70267e63175732"
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