class SwiProlog < Formula
  desc "ISOEdinburgh-style Prolog interpreter"
  homepage "https:www.swi-prolog.org"
  url "https:www.swi-prolog.orgdownloadstablesrcswipl-9.2.0.tar.gz"
  sha256 "10d90b15734d14d0d7972dc11a3584defd300d65a9f0b1185821af8c3896da5e"
  license "BSD-2-Clause"
  head "https:github.comSWI-Prologswipl-devel.git", branch: "master"

  livecheck do
    url "https:www.swi-prolog.orgdownloadstablesrc"
    regex(href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "1ab357e02d7694ca56d6e2376ab22e4eba50bad0de2a516d1f65e5e11c7a85f1"
    sha256 arm64_ventura:  "e49a0df728a7162220e7ed110f63a97a6b6126f146697ec8f49844da19c670d0"
    sha256 arm64_monterey: "f13fab1304502c0787a9484a22d21a337bd316896532801f0f7218354d742012"
    sha256 sonoma:         "7333bdac65627215d11b1773e06f97c6ffc2a8f9abc15e9376b11e189f3f8ab0"
    sha256 ventura:        "f53749156c058502abe3f56cb5e48f41bbf37e5ef6a427b53d44915d620590ec"
    sha256 monterey:       "7ca5d82d3492882c3998c283a89d05e64bd4a8ef6a358dd76a8b77a68f14efe9"
    sha256 x86_64_linux:   "a9c7eb7d096fa0fd5d56976ac99dbde2577423fb99ec2cb67db0ac5c49e6130c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmakeParams.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

    args = %W[
      -DSWIPL_PACKAGES_JAVA=OFF
      -DSWIPL_PACKAGES_X=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
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
    (testpath"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}swipl -s #{testpath}test.pl -g test -t halt")
  end
end