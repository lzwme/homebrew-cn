class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.0.20231217.0.tar.gz"
  version "p6.0.20231217.0"
  sha256 "9a666412ea5398143a4ce178ffb9decc5ec39e9d72dec8b4281aa38aa35c942b"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b067a3db8b0013a7fc193ab6f6d75073bdb58f5e1d24498a23baf226340c7530"
    sha256 cellar: :any,                 arm64_ventura:  "213a5b3d7c22c88babd65b730d812be82e6a6ed15823d20ffe8172b5547fbfad"
    sha256 cellar: :any,                 arm64_monterey: "871cd0c7432c3f16aa482ab103afddde067117c47bb6c6b83e8282f96ae2f6fc"
    sha256 cellar: :any,                 sonoma:         "850901a5bde9d243923cb67e002462b917c3d73d4d01cadb55d3a08dc3126c39"
    sha256 cellar: :any,                 ventura:        "8dc29cbe9fec51ba153d537072d947a1b3d50ec38588f8c1da42b93576c11f42"
    sha256 cellar: :any,                 monterey:       "4870c554a7038a4b12e9c7cdb9a369c3e0f3b24e46755015e5dff3214054d647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3aa82c34ce00b5d7b38d908654157cf72a6a9662fa00aa8660f0dca750298e8"
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