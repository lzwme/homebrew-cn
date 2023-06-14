class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://ghproxy.com/https://github.com/ccache/ccache/releases/download/v4.8.2/ccache-4.8.2.tar.xz"
  sha256 "3d3fb3f888a5b16c4fa7ee5214cca76348afd6130e8443de5f6f2424f2076a49"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02ecd933e834f58013d924090d13dafeb46a6f9606bf74b62205d06d47fe4b22"
    sha256 cellar: :any,                 arm64_monterey: "8ce666a0d2258dc9b6cbdf1ca02edc92369e44f36290da3ca13be7336eb0835d"
    sha256 cellar: :any,                 arm64_big_sur:  "c99b876a2c4e912e27f9d2b3cb4a1f7259707bbc58aafe4ed328b73dfb757a76"
    sha256 cellar: :any,                 ventura:        "f1bf50fc023daa9fe10c68c66758033e673953c93d3643227a5f50be5b63994b"
    sha256 cellar: :any,                 monterey:       "40b05ad0704bb9fd3cd1ede4ca7a21ee936c5ce819a77477c1c3ec8d4b62c091"
    sha256 cellar: :any,                 big_sur:        "5e48876771950ca60fb0e1cb6f708d27efe6d4704b58d275a994180611a4946d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867e06447d02727a3d24e651a578aa0440920367a1630b7f783ddfe686e1a7e8"
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
    # See https://github.com/Homebrew/homebrew-core/pull/83900#issuecomment-90624064
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
      libexec.install_symlink bin/"ccache" => prog
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
    assert_equal "#{opt_libexec}/gcc", shell_output("which gcc").chomp
    system "#{bin}/ccache", "-s"
  end
end