class Bstring < Formula
  desc "Fork of Paul Hsieh's Better String Library"
  homepage "https://mike.steinert.ca/bstring/"
  url "https://ghfast.top/https://github.com/msteinert/bstring/releases/download/v1.0.1/bstring-1.0.1.tar.xz"
  sha256 "a86b6b30f4ad2496784cc7f53eb449c994178b516935384c6707f381b9fe6056"
  license "BSD-3-Clause"
  head "https://github.com/msteinert/bstring.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbdfcc6c40fc5d3826b69cf194b712e96c6e9f3bb15fe6c6b487d161eeee1bf4"
    sha256 cellar: :any,                 arm64_sonoma:  "c25d14a3197a9508e1516cd3503b471ba15d1929b511533af28b6cbc54b9e5f6"
    sha256 cellar: :any,                 arm64_ventura: "3e7c981e0076bcadcbe655064492a4170b5e0c3a5bedd65a2a2244fcb18083a1"
    sha256 cellar: :any,                 sonoma:        "fea29e81c074efcc6b7ec34733ef211fb268e6d5877cba536f70a897a4cc96e2"
    sha256 cellar: :any,                 ventura:       "225f2b47a0fd47f5d935150bf17e8b836711874107a6993a98e5cacb02adc2b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d92eb7cf9024db94bb16ab6db8085ceb721d2ed2b2f0e8e56df1288d850a36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5c66d11cb49ef8c83637a7c0690b2dfcda8562107be84cc77a7efdfd9ee447"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "check" => :test

  def install
    args = %w[-Denable-docs=false -Denable-tests=false]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/bstest.c", "."

    check = Formula["check"]
    ENV.append_to_cflags "-I#{include} -I#{check.opt_include}"
    ENV.append "LDFLAGS", "-L#{lib} -L#{check.opt_lib}"
    ENV.append "LDLIBS", "-lbstring -lcheck"

    system "make", "bstest"
    system "./bstest"
  end
end