class Notcurses < Formula
  desc "Blingful character graphicsTUI library"
  homepage "https:nick-black.comdankwikiindex.phpNotcurses"
  url "https:github.comdankamongmennotcursesarchiverefstagsv3.0.14.tar.gz"
  sha256 "45afdda09d64c4a8bf2fc261dbbe5fa3784df6eff23a994778b234ee1d6fb30b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "bd0410ef78653cd668872a60757ae1d511a528c241fa731d6492466326577aa7"
    sha256 arm64_sonoma:  "2ef59aebd35df988465601461932553660e02dd3b3f3757450ed14ebac0c7466"
    sha256 arm64_ventura: "770852ab366e511def20a52488893d182eea03996abe341b1e9f359d3ef8637c"
    sha256 sonoma:        "a2c555e07b515d6c65a51be512d5468c0763835a2eaa8d9c2000c942ab796f02"
    sha256 ventura:       "58f4fcebb0c2dbddb967969040f2675767a1a2af1e44e4ed1a500ac4fcc8bd10"
    sha256 arm64_linux:   "10274f5ddecf011f0a2398dee8ab033ac943538403dd3ec11bcbe71a6d228e28"
    sha256 x86_64_linux:  "5d7057bb8ac0b5e9fb2d3fb8330665f38caab96f3c6720b71a03d74181528ee9"
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