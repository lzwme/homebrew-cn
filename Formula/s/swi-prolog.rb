class SwiProlog < Formula
  desc "ISOEdinburgh-style Prolog interpreter"
  homepage "https:www.swi-prolog.org"
  url "https:www.swi-prolog.orgdownloadstablesrcswipl-9.2.8.tar.gz"
  sha256 "b331637a57c913c49edcfcb10ddcf6c031278ce93d2411d54542778531abb5c7"
  license "BSD-2-Clause"
  head "https:github.comSWI-Prologswipl-devel.git", branch: "master"

  livecheck do
    url "https:www.swi-prolog.orgdownloadstablesrc"
    regex(href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "f6ceb36933e2448157545fef30536bd4c91467802f7a0ac51c457ac76a1a4f04"
    sha256 arm64_sonoma:  "ecbe24deec0df248adda3c44e789694aead64aeb4f4bb3ce1d48e60d6e5255c2"
    sha256 arm64_ventura: "108eabd3efffcb439ab4a884d66c0790122fb34ca91eb6f23963ed0ee18d42ed"
    sha256 sonoma:        "4473970903320547769a6380e6018a36acb004db8537e75e3917e79ead6818e4"
    sha256 ventura:       "a07dde9c433e634ea14448227ef6709e6bb1c90f31fe3658fc7b049e39d59afd"
    sha256 x86_64_linux:  "6d7123369a248a9b1226a72c9eeeb20970ae602b999ab96c8b5022b9ea8d5703"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DSWIPL_PACKAGES_JAVA=OFF
      -DSWIPL_PACKAGES_X=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
      -DSWIPL_CC=#{ENV.cc}
      -DSWIPL_CXX=#{ENV.cxx}
    ]
    if OS.mac?
      macosx_dependencies_from = case HOMEBREW_PREFIX.to_s
      when "usrlocal"
        "HomebrewLocal"
      when "opthomebrew"
        "HomebrewOpt"
      else
        HOMEBREW_PREFIX
      end
      args << "-DMACOSX_DEPENDENCIES_FROM=#{macosx_dependencies_from}"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.pl").write <<~PROLOG
      test :-
          write('Homebrew').
    PROLOG
    assert_equal "Homebrew", shell_output("#{bin}swipl -s #{testpath}test.pl -g test -t halt")
  end
end