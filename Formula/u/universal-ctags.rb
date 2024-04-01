class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240331.0.tar.gz"
  version "p6.1.20240331.0"
  sha256 "929090bddc54acc18d297ae53c79f514119320ef5ef748a7a0dfc9fbe1e8714c"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df1ba52fcbd533bd081f9991d7b0020fc109830e6316eae07172aafdb7cbb998"
    sha256 cellar: :any,                 arm64_ventura:  "569a424a310d91d5648e484829cf15bf70e672d5c2c989a7bd4bf2644bdf5b70"
    sha256 cellar: :any,                 arm64_monterey: "4622fb18bf47ae9e34a39cc9f9494079ca7d1eb2a9a4bf1ff205d7194fb720cb"
    sha256 cellar: :any,                 sonoma:         "a55effac22f771a18978460467bc0a28d96cbde76f07257a03906a4e2f221d0b"
    sha256 cellar: :any,                 ventura:        "2a199c23682244e2e3687d01b7e5d477fcadada96f37cc1d1ac5b0dd7e758231"
    sha256 cellar: :any,                 monterey:       "53d289776b44eed0066ac41c985468864dafdb58a833b5fbcc461d748ba40a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75773757b373ec44fa0dd61a80eb4cccf74a7161f18abaeff49e8d972ca76151"
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