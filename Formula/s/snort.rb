class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.1.83.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.1.83.0.tar.gz"
  sha256 "1092d3145e10111c12bcc244f6b2d876c5acf890554dc688e210d5a25c3592c2"
  license "GPL-2.0-only"
  head "https:github.comsnort3snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ed0093e5d88d0431c6d40967147fd41141049499c9ae7e76aefbd3b73a93c29"
    sha256 cellar: :any,                 arm64_ventura:  "bc5bbfe720027983a5b623de7048d41aacb7205643bf675f0183b5ed180291f4"
    sha256 cellar: :any,                 arm64_monterey: "13db25a413674e043c24c3493068a4e726138b68221eb96e5d04e01e0528c42f"
    sha256 cellar: :any,                 sonoma:         "50c1c2095075015cebd3916b13164843c2cc9fd3976510ad921744fa8708f4fd"
    sha256 cellar: :any,                 ventura:        "d0abab8e24135363e6e0cfe4e35cbfb00600c6f79267520f75c533ac1725b349"
    sha256 cellar: :any,                 monterey:       "f8ff91c29f4d2e4974ce6335b4ab3336fbc866d2d82a18fbd8ed3a3282f1c82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2423d498d3d36ccdd52bfbcb7fd11cbc1d4ac70e27f564015244eda39e7f144b"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https:github.comsnort3snort3issues254
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  on_arm do
    depends_on "vectorscan"
  end

  on_intel do
    depends_on "hyperscan"
  end

  fails_with gcc: "5"

  def install
    # Work around `std::ptr_fun` usage.
    # Issue ref: https:github.comsnort3snort3issues347
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS" if ENV.compiler == :clang

    # These flags are not needed for LuaJIT 2.1 (Ref: https:luajit.orginstall.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmakeFindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      For snort to be functional, you need to update the permissions for devbpf*
      so that they can be read by non-root users.  This can be done manually using:
          sudo chmod o+r devbpf*
      or you could create a startup item to do this for you.
    EOS
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}snort -V")
  end
end