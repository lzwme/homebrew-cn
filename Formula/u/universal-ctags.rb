class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://ghfast.top/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250921.0.tar.gz"
  version "p6.2.20250921.0"
  sha256 "3000cd099ea0ffa23253384360043b74e1813204bbad8383959a919c7a7534f0"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8001dcd24f81ea5d772eb411265f6e61706b16748e782b7b130df98d5d829c30"
    sha256 cellar: :any,                 arm64_sequoia: "4d187cad35657e426b870b3beb07ae27e4694a4333adeb457458f3d07a9ff09d"
    sha256 cellar: :any,                 arm64_sonoma:  "434b02e5d1b21277d635ba94ace800ffef9dde29559f6f204729bb3808392df3"
    sha256 cellar: :any,                 sonoma:        "1307d56a09fd1212154b2d013c088bb3d075f13e91978ee10f2aa4c12fd15646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b143e3ca531ae09a3cf31afe6cec9d7293f48573ca7c0aecc6660afedab8f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857ab6df25fdea0d72a87d99cc74771bb727550fa90c4e49cf31c778fc8f49c4"
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