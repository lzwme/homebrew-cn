class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://ghproxy.com/https://github.com/cisco/ChezScheme/archive/v9.5.8a.tar.gz"
  version "9.5.8a"
  sha256 "1071a75b9374a1331e7f18a3464308bb2ece2169ece324570a9cdfc017d9bf46"
  license "Apache-2.0"

  bottle do
    sha256                               ventura:      "ae89fa0863fd308e46b19e466086fa288db05c20fc6d2daca8583a5e55941f97"
    sha256                               monterey:     "8d686736d4430ed5a8b7dc5e78fcc14e4e046d9d2aeb0595a083fe1a63a1abc3"
    sha256                               big_sur:      "ab767da2684c603854013e9719e6038251400a7577a5112e9dd61b35770a6162"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3a8d1a9705e9ea91c931daae9eedd085efbe7f58a6f532adfb922086ecb4cc4e"
  end

  depends_on "libx11" => :build
  depends_on arch: :x86_64 # https://github.com/cisco/ChezScheme/issues/544
  depends_on "xterm"
  uses_from_macos "ncurses"

  def install
    inreplace "configure", "/opt/X11", Formula["libx11"].opt_prefix
    inreplace Dir["c/Mf-*osx"], "/opt/X11", Formula["libx11"].opt_prefix
    inreplace "c/version.h", "/usr/X11R6", Formula["libx11"].opt_prefix
    inreplace "c/expeditor.c", "/usr/X11/bin/resize", Formula["xterm"].opt_bin/"resize"

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end