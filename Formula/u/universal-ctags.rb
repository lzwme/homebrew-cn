class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250126.0.tar.gz"
  version "p6.1.20250126.0"
  sha256 "452a37570a55889fd8b43f0dd0493c5c40f4b3accd220a80fc741d9dffeb650e"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7bca62cb34ef84943b2d0fa70f94881f0447f2745e950399d6059e53c2e4128"
    sha256 cellar: :any,                 arm64_sonoma:  "ece4f2e2824a84083791f6990bcc3aa0a4e651d22a1f3aee9e299c6f179ddab3"
    sha256 cellar: :any,                 arm64_ventura: "7f25c854f352f1addd908b1ff78bd1ae0eae434018b4ce19023728ed859ca28f"
    sha256 cellar: :any,                 sonoma:        "1836b74e9b09c47723b574940af28b0011b2132597fb3d3abfc3d1aaf4da3092"
    sha256 cellar: :any,                 ventura:       "da820b30f54e5ee15ea943bd0f16ba18f4afb2cc10a7fcc2c46311b4028e2f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16202f3c1a3cd9ddd5e20d26a9b84b4452379f53c0e1b4b993d0f28e9ae8c7f1"
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