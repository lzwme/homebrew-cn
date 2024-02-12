class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20240211.0.tar.gz"
  version "p6.1.20240211.0"
  sha256 "63426af2d332179a5d9dc4cdcfe183ede74d4c5e87c6d8c56e7f32a72f053501"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5cc79b0c69fe7905ca06dcbff1e7474f454f4c2d906ced4fbcf3318948927fa1"
    sha256 cellar: :any,                 arm64_ventura:  "97b4e723361edc2968e36206c08225dc5ab9b1d195ce759fadf2c3a4ac8d88a8"
    sha256 cellar: :any,                 arm64_monterey: "bb0fc8593f4ad6c0c7c8e5866a2e9033a63b5cbcbf78ad138ad21f007f75eeb5"
    sha256 cellar: :any,                 sonoma:         "5ffc60ca21fe8ee04ae442e118b76178676c638dce6b6ee24e08ac0a2d7bc4fa"
    sha256 cellar: :any,                 ventura:        "7cc9252e764a587b41b5c31bd6cba52cecbdaabe87a8cd65b7673dfbf6ba3801"
    sha256 cellar: :any,                 monterey:       "6cf37b6aec7b8303da29e1f323471b0042fdaaaa5398476fbbd1c17c5d9239c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff71fbc75233da2039b5350deb95dc5e9414be40aa6284490bb29125c6a54fd"
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