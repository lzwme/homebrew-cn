class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://ghproxy.com/https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230521.0.tar.gz"
  version "p6.0.20230521.0"
  sha256 "479ade93d7e3b6225e7e4ce0191209477d68894b5e3f1f8ed45e3db17c42d274"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "92712ac1df7781fc77b9731fc7aeffed391d3a768df3158cf936c0d560217990"
    sha256 cellar: :any,                 arm64_monterey: "4a66bbd3eeaf324c458c0317a5a76b2dadcc7492f092ed356f16f61cc8350493"
    sha256 cellar: :any,                 arm64_big_sur:  "bea8d9b3ff4198e0e8aea825de4ce2ccbd87f3e5730991e919f05bcf145d4b46"
    sha256 cellar: :any,                 ventura:        "c24db5f0fd420a7531a4ca8ff38b62aa90c595d28214eb3f9cacfee97f4e1cc1"
    sha256 cellar: :any,                 monterey:       "fdbb67953df655472ad1e79583f55c32c2deaddcf7209cfef65f7d012cae9b17"
    sha256 cellar: :any,                 big_sur:        "7c92bb25d2f1ee408988684518b9e4b4f165edfa79e31947d5f54cc16fd0926b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62ab260d9dfe39343a5413c2bc51cd84516ddbd209a8b80a961463a9144fe03"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
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