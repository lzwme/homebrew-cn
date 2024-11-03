class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https:github.comuniversal-ctagsctags"
  url "https:github.comuniversal-ctagsctagsarchiverefstagsp6.1.20241103.0.tar.gz"
  version "p6.1.20241103.0"
  sha256 "a31de56fece3252c105f212f2cb25b60772fe009e37ecc7caa8140df49b665d6"
  license "GPL-2.0-only"
  head "https:github.comuniversal-ctagsctags.git", branch: "master"

  livecheck do
    url :stable
    regex(^(p\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a6b390e6cf51b39e408f78f0efa45d58177568ef772028bffa45d2ed1748e68"
    sha256 cellar: :any,                 arm64_sonoma:  "1ef6b540793e25b8cb93439943de853c47d13cb57aaea286e7216a25da3ff2bd"
    sha256 cellar: :any,                 arm64_ventura: "d6d53404a35b701eed44d7210e6aa33ca7e4c43b688e76f76f1f8256147725c6"
    sha256 cellar: :any,                 sonoma:        "7d1ed72f0af0bbbef6acffb6ab2a5dc23f9d735f09e3fe6fb5555722ca69b2ac"
    sha256 cellar: :any,                 ventura:       "71232505e844d086f9023cb25dc2e896ae7b28d184a778f330f04e26f6d472af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2753207d36633bbd71c48665c449c3dbea0b999ff46a0be5b6b3b9d0b877c006"
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