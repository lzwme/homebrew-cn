class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghproxy.com/https://github.com/snort3/snort3/archive/refs/tags/3.1.73.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.73.0.tar.gz"
  sha256 "d04edf07e9b695fb22de73f0987537d35b4c8466119940e39a056d1a13888b27"
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
    sha256 cellar: :any,                 arm64_ventura:  "2ebce7964ef455dd3e2c98ead05afcd43c2770b57929ed2060e1db46e6e86401"
    sha256 cellar: :any,                 arm64_monterey: "530e56ad93831a107a7a4ab69e82a6e49e133af0a419836e9d823cb430fcc0cf"
    sha256 cellar: :any,                 ventura:        "5c51a03a1db0f4e1540b81b3d7f26fd9d9bdf1366b78b1a111bbbd82d5ccd89f"
    sha256 cellar: :any,                 monterey:       "f2a04f6cfdbd550f31a819c73b25d1fa50966d2046b2879486051dd30b7eaf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d961147f9abef88d2eb5ebb0987a51c354d8d54c5d5b192c76ca1790144f400"
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