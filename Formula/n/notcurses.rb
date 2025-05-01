class Notcurses < Formula
  desc "Blingful character graphicsTUI library"
  homepage "https:nick-black.comdankwikiindex.phpNotcurses"
  url "https:github.comdankamongmennotcursesarchiverefstagsv3.0.15.tar.gz"
  sha256 "e811c24784559363d311c08caa74a0f7e7138e4ac8e8f6f51cbf6c565e363811"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "0c2ea596b5f779e4c265f6a0922ab336a907e32b86cc39022ad87fd73996952b"
    sha256 arm64_sonoma:  "d728a045ad731b37521b2bc89fc897dd29929751e7c9fcba0a67c97a52ff57e3"
    sha256 arm64_ventura: "cebb3e0a7d25da2decdd293d9cdec174301718e7b1bb9d6b5f754017d2d9543d"
    sha256 sonoma:        "edc6f3cd8f16436a349db2b89c930d28229d1f40bab8306112d00a5c5e028e06"
    sha256 ventura:       "3f489e32e234ef9e91559d75a2f551761ba3ced9b00aad2a577aa4bea6380884"
    sha256 arm64_linux:   "d6898c7d98411d82cfd39832df9f3d4025c10de012a70b22dd1f7f23d7f7937c"
    sha256 x86_64_linux:  "79a904efd399b17504a0b703c7e3b58a9f4535b1fe5de58e317bd55b13ed9d34"
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