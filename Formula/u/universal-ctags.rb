class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:ctags.io"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250323.0.tar.gz"
  version "p6.1.20250323.0"
  sha256 "8b1c2b20186ed244a3c212004a8d66a3deeadf3bfa484e9eba244a53a0e3a5cc"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d32893943bcaa8c75845c071a501858b1a0923f2cb782df3b8bfaad988dd403c"
    sha256 cellar: :any,                 arm64_sonoma:  "58d05780438c490d56b0ff2215f055821da1a4f29f2077a70d07ef19b2b79724"
    sha256 cellar: :any,                 arm64_ventura: "e0d713277f1a532be998d7ccf71311a6a0e2652eba557014d5dd9d02f718506f"
    sha256 cellar: :any,                 sonoma:        "1f27666ed2a0a04c242892ee8baf16fc9ecf241929f8e46e637f59e2e83aaa29"
    sha256 cellar: :any,                 ventura:       "abdf3ed97caa76a9bf495de48df623e250fcf38136b74565e92ca6ec6e7e5042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baff371e4a356522a8a64ad55ff7ff435c744cf954a592d30ff0b7e785b63b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8532c971646c48a29c45fbf434d640a6320b30ec711e5ca84d2dd5623eabbc86"
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