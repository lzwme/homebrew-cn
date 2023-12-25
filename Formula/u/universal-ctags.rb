class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.0.20231224.0.tar.gz"
  version "p6.0.20231224.0"
  sha256 "357ca1743d5927db2b1735e2dbb7add7f195e62cf5854e9d0d9dfadfd7e3603c"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "90833bfbfaa8a1c9ec3f32f2acebbdc9fdf88c0b4ad78f94240dd67ecad18a74"
    sha256 cellar: :any,                 arm64_ventura:  "240351d49e1a312746cce49f6ffb68fc658d31181abbaa9acc5e89d6acf7c98c"
    sha256 cellar: :any,                 arm64_monterey: "3db10aefb31cf7aacb0ee022226696a4821cf6add7fa37fed87fbd28be0a9ce0"
    sha256 cellar: :any,                 sonoma:         "7250ad2c26f516d8dc7f30c689324d56415f2353fae1b37521f7ef0aef75dccc"
    sha256 cellar: :any,                 ventura:        "edec6a810ab132940c5d15ab600476741e43cf0072ef957f7164d517f023928c"
    sha256 cellar: :any,                 monterey:       "6f9c1932020e136e05a164a3c2963802255a288c8c3fa4b772a57e74111cba1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825cd79ac35cee23773f4d34ffa1f1f2dac3fc26642893e69b7359d70e6dd2c1"
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