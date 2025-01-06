class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20250105.0.tar.gz"
  version "p6.1.20250105.0"
  sha256 "d4e6932f5d2dfed3f2fe1c11a601a93bf4983f6677db62c38bdccdfc25ac77da"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cbc0bb53bc1fe286e9dd5db7b5f4987a4347745fa0a33fbcd55f332b3c3176b"
    sha256 cellar: :any,                 arm64_sonoma:  "56c373cec76b8070314f518e32edd367ca421c3c867cafe751acb7c7ad2e8807"
    sha256 cellar: :any,                 arm64_ventura: "126f3ef4916f220ac85538368d7ee3ecd299730525ba903c634b2ccb16d2b913"
    sha256 cellar: :any,                 sonoma:        "4a404fce6544a1f6eea5ef472f8e093185488143df5ec32c5fe2609496b57475"
    sha256 cellar: :any,                 ventura:       "d5da4977be3cb1be6ff58187a128435910830e25f9f894dab6791a4ef2e6947f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5df3180ca165f4d328393ca480d5b4fbc2a0e09859d603863cb8170868e03c6"
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