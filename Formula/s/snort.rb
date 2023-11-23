class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghproxy.com/https://github.com/snort3/snort3/archive/refs/tags/3.1.75.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.75.0.tar.gz"
  sha256 "c1a1b7d00df5ab45df968f0fb0125eba95bad27c181018b8d68a41e1bb6fc111"
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
    sha256 cellar: :any,                 arm64_ventura:  "d14a03115761cf29dc57fb07bade8548badd6991c72fb7a505774221eb1055b5"
    sha256 cellar: :any,                 arm64_monterey: "f8d44f17299c1b8ddae35f19412ebf80878d82b1580fcaf7f75e7d553baaabea"
    sha256 cellar: :any,                 ventura:        "ab77e83843f9d2e83eda854e68d39ced5784c71a87ccc9eeb775d0fd088616d2"
    sha256 cellar: :any,                 monterey:       "eca2357accb2e8abc49f18dd6faffac7074f73eb77ce3977cb48ef6fa5e0c4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f476aba56729c901acc81dd281e0513e893e7f1fa5b27dcdf2f813580d057fe3"
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