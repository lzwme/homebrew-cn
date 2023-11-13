class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20231112.0.tar.gz"
  version "p6.0.20231112.0"
  sha256 "6625afe878429ccbc36cef7f0ad6672fd596b25f2d5ece7573a6322f761952f7"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd35c8b2c6167493d882ae0526c9c853c03d0f18ee623b624a9ed92df579e3a7"
    sha256 cellar: :any,                 arm64_ventura:  "bacfca6eb84ec9617401a56e2d5943db55990104edafe686dfefbb5d68322b38"
    sha256 cellar: :any,                 arm64_monterey: "878da8eafc1ad92c4b8d67498f4495cafc287cbeac0063c60dff9f5d6e8460e5"
    sha256 cellar: :any,                 sonoma:         "1589e739a125e93d6dc016cb6b671c4662e1dd5133b2a73fecede55322d36cdc"
    sha256 cellar: :any,                 ventura:        "8a4c5fcb5e824760f7087e894e71c7c0e522d9e0fa4e367d845a7455d34090d3"
    sha256 cellar: :any,                 monterey:       "fbc4b1c96e61baf661d5cb7cae587c4557818d8f881bae522420f4066b123e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b7765c8ae7b45a0e769eb093e873f965e2157eb13ab29234db7540f643d01e"
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
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end