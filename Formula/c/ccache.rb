# TODO: Add this to Homebrew so it can be used as a dependency:
#       https:github.commartinmoenespan-lite
class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https:ccache.dev"
  url "https:github.comccacheccachereleasesdownloadv4.10ccache-4.10.tar.xz"
  sha256 "83630b5e922b998ab2538823e0cad962c0f956fad1fcf443dd5288269a069660"
  license "GPL-3.0-or-later"
  head "https:github.comccacheccache.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "362e29807c48743ef00cab49b7872258f5636f449e966bbc0b386dc5a1f05818"
    sha256 cellar: :any,                 arm64_ventura:  "f1cf9d4ae9fd82ab535acf13b409121d5f02afce7a5c519dd76003a2ed90435d"
    sha256 cellar: :any,                 arm64_monterey: "23c1ddf2956b4f0a119485a46f6501f70b71c7382de7764d782e04c53ad16cf5"
    sha256 cellar: :any,                 sonoma:         "f703c1bd5db344995f4b4c88e4027e69499c74a38dd9afec1e7a969e160a0ffa"
    sha256 cellar: :any,                 ventura:        "e17b749981c76783e243bcea96d4041155dce095b422ecdc071706b5de165aa9"
    sha256 cellar: :any,                 monterey:       "52bc73a6c84e522d694703e4451a5244c1838d72d8879aed4d3cef5fddd43d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "991a5800ee133ad0535c8a28de13c3e6f5e3d14a5dbf6b8e0f5cdc92c80d79d2"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "cpp-httplib" => :build
  depends_on "doctest" => :build
  depends_on "pkg-config" => :build
  depends_on "tl-expected" => :build
  depends_on "blake3"
  depends_on "fmt"
  depends_on "hiredis"
  depends_on "xxhash"
  depends_on "zstd"

  fails_with gcc: "5"

  # Fix detection of system blake3
  # https:github.comccacheccachepull1464
  patch do
    url "https:github.comccacheccachecommitd159306db8398da233df6481ac3fd83460ef0f0b.patch?full_index=1"
    sha256 "1db1a39677b94cd365b98d8df1fcd0b116866175d4a55730af9bfa1ab443e4be"
  end

  # Fix blake3 include. Same PR as above.
  patch do
    url "https:github.comccacheccachecommitfa4046966e71011587364b0241255130b62858fb.patch?full_index=1"
    sha256 "c0d5d61e3ef594c0587e249798e95c9d508f41452fd649685b8f6a00e667be80"
  end

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