class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https:ccache.dev"
  url "https:github.comccacheccachereleasesdownloadv4.9.1ccache-4.9.1.tar.xz"
  sha256 "4c03bc840699127d16c3f0e6112e3f40ce6a230d5873daa78c60a59c7ef59d25"
  license "GPL-3.0-or-later"
  head "https:github.comccacheccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36439d2640ce457feb19be3977239b337af37677ce0017711a7aff445293bfb4"
    sha256 cellar: :any,                 arm64_ventura:  "a39f209c57851f387afdd68c2af38b55e30d4f1745daf93fb4380596ab49ef2f"
    sha256 cellar: :any,                 arm64_monterey: "69ff878599172a0665ea8d3b689f67503498ec9e8ec48bba227073a33f38ec31"
    sha256 cellar: :any,                 sonoma:         "82ae050381cb8d0359f1b3f5ecc8daffa4b5081e5843cb6598f166ab8ece0c8e"
    sha256 cellar: :any,                 ventura:        "f94f3cdbacfdd9c0cd31f4106063ed333552677cee43988babb370940d55fe2f"
    sha256 cellar: :any,                 monterey:       "f517de050ecca8e7f8cf3eba39f82b4bcda1bb4dbb2420ef798e8578738e17dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b495d23804e8db7fd38d0b999d68e3d4849d0c8f2d0b6ae2e34bdce93dd8df3"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "hiredis"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_IPO=TRUE"
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
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11 gcc-12 gcc-13
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11 c++-12 c++-13
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11 g++-12 g++-13
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