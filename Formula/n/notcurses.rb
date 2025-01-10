class Notcurses < Formula
  desc "Blingful character graphicsTUI library"
  homepage "https:nick-black.comdankwikiindex.phpNotcurses"
  url "https:github.comdankamongmennotcursesarchiverefstagsv3.0.12.tar.gz"
  sha256 "3f7f5b7f0605c3d35627a4f3f39e067dfbd7ce4530b6d24a27937a01e67056dc"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "a525346da038e065a35f67dce832a40162ad0e29ce41ae140533f2fdc6b189b8"
    sha256 arm64_sonoma:  "f55dda3f3c1871a5b33cb2fd8137e5e7c72fd331b74455cd1d373d235e89534e"
    sha256 arm64_ventura: "01f36e47c63670b39e8de394bf3fd49eaf97cd57e912f009e745d61d2019b93f"
    sha256 sonoma:        "5f5cf55893d686212bbb8c0d60853d8be9d4796718a7a1f2e29aef4cc5616f96"
    sha256 ventura:       "c72472fb5827d0b57c1c1c2fc4a872837a5511deffbf9c1e794bfb86595403b1"
    sha256 x86_64_linux:  "3049084941e32c92c1c2a73c51f75789d41c469653dfd8aca39e73273c73719b"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output(bin"notcurses-info", 1)
  end
end