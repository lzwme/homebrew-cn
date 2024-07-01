class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https:ccache.dev"
  url "https:github.comccacheccachereleasesdownloadv4.10.1ccache-4.10.1.tar.xz"
  sha256 "3a43442ce3916ea48bb6ccf6f850891cbff01d1feddff7cd4bbd49c5cf1188f6"
  license "GPL-3.0-or-later"
  head "https:github.comccacheccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "430b224f19756fc5d226cf68ce209b4450738b47127a05a3089e255f59721b74"
    sha256 cellar: :any,                 arm64_ventura:  "27f66da31f0b7c0874a0a5c736f3427ba5576279a5548f5c701ea634f8a66c62"
    sha256 cellar: :any,                 arm64_monterey: "9625bf6777aba2d25a406ef62fdbb7b8f70cbeb7c47bfdea7054c5dd3c24cd21"
    sha256 cellar: :any,                 sonoma:         "2e97103e91c45076427780d4d3f00b2c4aa127292ae5fb4cb79487d47da007e5"
    sha256 cellar: :any,                 ventura:        "b927910be81371b99234bc6035ea750b1b7a661bb5f001c12bb3d95e7ed47119"
    sha256 cellar: :any,                 monterey:       "65662794d7d69a1db73d53a37dcb55d3945b6afcdf2d65af6cf72811cbfc4722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29bd86ce0666b328b52a5f3c4e4c982041aac5f8e3cb6efe3fb4da750f4f4561"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "cpp-httplib" => :build
  depends_on "doctest" => :build
  depends_on "pkg-config" => :build
  depends_on "span-lite" => :build
  depends_on "tl-expected" => :build
  depends_on "blake3"
  depends_on "fmt"
  depends_on "hiredis"
  depends_on "xxhash"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_IPO=TRUE",
                    "-DREDIS_STORAGE_BACKEND=ON",
                    "-DDEPS=LOCAL",
                    *std_cmake_args
    system "cmake", "--build", "build"

    # Homebrew compiler shim actively prevents ccache usage (see caveats), which will break the test suite.
    # We run the test suite for ccache because it provides a more in-depth functional test of the software
    # (especially with IPO enabled), adds negligible time to the build process, and we don't actually test
    # this formula properly in the test block since doing so would be too complicated.
    # See https:github.comHomebrewhomebrew-corepull83900#issuecomment-90624064
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "-j#{ENV.make_jobs}", "--test-dir", "build"
    end

    system "cmake", "--install", "build"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0
      gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11 gcc-12 gcc-13 gcc-14
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11 c++-12 c++-13 c++-14
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11 g++-12 g++-13 g++-14
      i686-w64-mingw32-gcc i686-w64-mingw32-g++
      x86_64-w64-mingw32-gcc x86_64-w64-mingw32-g++
    ].each do |prog|
      libexec.install_symlink bin"ccache" => prog
    end
  end

  def caveats
    <<~EOS
      To install symlinks for compilers that will automatically use
      ccache, prepend this directory to your PATH:
        #{opt_libexec}

      If this is an upgrade and you have previously added the symlinks to
      your PATH, you may need to modify it to the path specified above so
      it points to the current version.

      NOTE: ccache can prevent some software from compiling.
      ALSO NOTE: The brew command, by design, will never use ccache.
    EOS
  end

  test do
    ENV.prepend_path "PATH", opt_libexec
    assert_equal "#{opt_libexec}gcc", shell_output("which gcc").chomp
    system "#{bin}ccache", "-s"
  end
end