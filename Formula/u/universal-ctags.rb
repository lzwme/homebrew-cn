class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251005.0.tar.gz"
  version "p6.2.20251005.0"
  sha256 "67be867027ac7451750e93923f15ce305ad814d4971cda8b0dd108a91bec6b0c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "123d17f147e053d89f1dc5eedcf2e81e535fc302c89d2499b0097171f04e8ea2"
    sha256 cellar: :any,                 arm64_sequoia: "f4cf1177ef3393760e03b83bd1614f1d8025d995d83d19e1ed9303ea9adb90e2"
    sha256 cellar: :any,                 arm64_sonoma:  "8638aa24aa7cdb934c3e1292d97499cfaad1f66d33595bc9a2aef2efb03b233b"
    sha256 cellar: :any,                 sonoma:        "0bd4b1b47e11702810ff678c5cdd97dd55ff6818877093e8b7a5ab43cd648f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96ff488c5bd54e3f5fe4df520e87ab6ce568d2104def6d16a21027084821141d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820f9d5e4a4321eadef96ec5e73f08ccf7c0c323015d21bcd7a224bdc854c304"
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