class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251012.0.tar.gz"
  version "p6.2.20251012.0"
  sha256 "e8d0787ec162d78e63e91304c3b9cede4db3be8d8219c5150461cb36b5dc0362"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b06b89fa38659e6f0e43caaea7e81f9d5ededfc49ec8812675dfc74fc0fe6f2a"
    sha256 cellar: :any,                 arm64_sequoia: "6b7f8bcd552469849abb9eac29889a7604fc37afb61e2feb831cbdebc505e6ee"
    sha256 cellar: :any,                 arm64_sonoma:  "641195bc1067870089008780f6812408bb264699143d4e6dc47903d6850d9cd2"
    sha256 cellar: :any,                 sonoma:        "d54acea4517cc860edee4fc395549c54b3325b5c86d967716ee2f2889f4c9343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489214ffcafc1f48a78b96a5cafc9dcbae8575a15eef79d952d0e7f59a249b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0060e3272664fc3451ce42c4df6e409d4ed23ee6cf13120c520f4a0b433e9b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end