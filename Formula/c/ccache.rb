class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https:ccache.dev"
  url "https:github.comccacheccachereleasesdownloadv4.10.2ccache-4.10.2.tar.xz"
  sha256 "c0b85ddfc1a3e77b105ec9ada2d24aad617fa0b447c6a94d55890972810f0f5a"
  license "GPL-3.0-or-later"
  revision 2
  head "https:github.comccacheccache.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "f579fb759bc19c5bdaefe98edcc98900a4cbdcab84a53ddb5b4c0f7f1ace87fe"
    sha256 cellar: :any, arm64_sonoma:  "fe3fdca6302d724a4dd94e770d8c76d1dc93a4ce1a4d2cdb8d0f547589484adc"
    sha256 cellar: :any, arm64_ventura: "2d4ba037e81c3c32357d99cad21372047d63ac262f1d9680ff2a359f25548127"
    sha256               sonoma:        "add9f5c2e6333590ddf595df4c1d18dbce7d93d58600b8e7d9147108fcd23487"
    sha256               ventura:       "6bfe8cf501277887d4e33639b72725f419cb3fcd8dd194567659993f012b98da"
    sha256               x86_64_linux:  "aca73980ba2708628df1b3b4b2fcd0a5b1b38d79e0a97d34e8a27a0de05d812b"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "cpp-httplib" => :build
  depends_on "doctest" => :build
  depends_on "pkgconf" => :build
  depends_on "span-lite" => :build
  depends_on "tl-expected" => :build
  depends_on "blake3"
  depends_on "fmt"
  depends_on "hiredis"
  depends_on "xxhash"
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
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
    system bin"ccache", "-s"
    # Calling `--help` can catch issues with fmt upgrades.
    # https:github.comorgsHomebrewdiscussions5830
    system bin"ccache", "--help"
  end
end