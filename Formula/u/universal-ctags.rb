class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240915.0.tar.gz"
  version "p6.1.20240915.0"
  sha256 "afdb2718b00e7d111ff541303af835add04dd0a75df514cf7b7deaacf6922439"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fa6d5cc1261256a9099fe2d4eba6f43bcb559912ea6a5a61c02661725c11875"
    sha256 cellar: :any,                 arm64_sonoma:  "50887b9c15efe6acab7d45b54d7ec1f4cd2b678025a106a86d5fcf2688c5f43b"
    sha256 cellar: :any,                 arm64_ventura: "9765ec737523b146c281e021145734aa448fff1b4a7ca744a358348220c63375"
    sha256 cellar: :any,                 sonoma:        "06bbc544010020ce2845508f94e64c0641859c0572b4119592e707ffeea0ab07"
    sha256 cellar: :any,                 ventura:       "901c179611a926dc664a4ace06390bb9d736c23ab35ea54fc863bebfb6c49be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e29f7b1de7054ce02fa48de1c803c069da9e38ea2b2c482703ca8849b571b6b"
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