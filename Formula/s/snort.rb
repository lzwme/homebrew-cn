class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghproxy.com/https://github.com/snort3/snort3/archive/3.1.71.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.71.0.tar.gz"
  sha256 "b5dd52b46ca2570986d7c12750bbf9db00ee3c294983ce272b3ca321aee8fb73"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "96d45e7d0d6d84febe9fc534dbcffc7bd74751420c5994531cc00d7a581872d2"
    sha256 cellar: :any,                 arm64_monterey: "2edc41ee32704fdf4018b461bdbebf8a86e3f523770ed29c2b69d78a56189c06"
    sha256 cellar: :any,                 ventura:        "e40cbc71919410cd8c9b512576b403f078715582807b02e6bf241273c1f541ef"
    sha256 cellar: :any,                 monterey:       "444174af05603622abc1c6f4d2826205ec38a51101a065978e6172ee81ea07af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7faa1f7b98e519f4de802cbe2da05dfb2114d9107f37410c6de62bf35487b888"
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
  depends_on "pcre"
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
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      For snort to be functional, you need to update the permissions for /dev/bpf*
      so that they can be read by non-root users.  This can be done manually using:
          sudo chmod o+r /dev/bpf*
      or you could create a startup item to do this for you.
    EOS
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/snort -V")
  end
end