class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https:ccache.dev"
  url "https:github.comccacheccachereleasesdownloadv4.9ccache-4.9.tar.xz"
  sha256 "1ebc72324e3ab52af0b562bf54189d108e85eef6478d6304a345a3c2dc4018e0"
  license "GPL-3.0-or-later"
  head "https:github.comccacheccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32e0fbe3dfb4ea83d7e83cc627572a61dbd1c2564fb86245d44055654d1ac46d"
    sha256 cellar: :any,                 arm64_ventura:  "8eec8948f9c7cb88af735be4a189c7156acdbac02b48c0e43ec76b575f9e35cb"
    sha256 cellar: :any,                 arm64_monterey: "509e0c692ee384979396ae89b861db5782ad5d7c18f43e236bfaf173f9280b70"
    sha256 cellar: :any,                 sonoma:         "1e721a38ceeff1b5bb9d9f7e25ad63a6d82547da6d1a5ef943941dc5f30436c4"
    sha256 cellar: :any,                 ventura:        "31dc37b131e29c93776e7237c56a0667541b897286eec430b2b8318e730d84ca"
    sha256 cellar: :any,                 monterey:       "0c861be304655a757248eaafffb414dcd00692b5a6131ed57879dc84fc2c30b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b042bcc383f07d388fff83dfd5b303d8b98ab98a83d1ccc4c8b4da01e6cdee"
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