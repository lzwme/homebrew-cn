class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.12.4.0.tar.gz"
  sha256 "5bab33f703ca09b74bc2de72d16d8be59c67ebb98dbd45e50c30989b5cdd510f"
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
    sha256 cellar: :any, arm64_golden_gate: "cc1bdc46cab2d0e8dfe91dbc2b4bc099ad9e9922434289fcfe8a54f6e1a7f077"
    sha256 cellar: :any, arm64_tahoe:       "ba9d35f0404200941261b2b72ee4fc721d70210cafe11b51e733c9b73c12db0f"
    sha256 cellar: :any, arm64_sequoia:     "e50af48297095b6d1698460fa90fb159b0a65a26ab93bb7f138cbcf10dc0efcf"
    sha256 cellar: :any, arm64_linux:       "2a8d037c853d40691dc67dfd1a05a46d60e73a2c8bea5ca9b9903b9a8a271a05"
    sha256 cellar: :any, x86_64_linux:      "9589d0ea20a7097a7cd557179cae739e3cf411bda149921410c4a4fa4088e762"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkgconf" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  # Apply open PR for OpenSSL 4.0 support
  patch do
    url "https://github.com/snort3/snort3/commit/286352b0e3f3e0798666d4f78ca35668d8695ab5.patch?full_index=1"
    sha256 "8707359cf1854a85bf7f48e8e8b5a949739e0965ee55078bfdef033055971fc7"
    type :unofficial
    resolves "https://github.com/snort3/snort3/pull/477"
  end

  deny_network_access!

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https://github.com/snort3/snort3/pull/370
    inreplace "src/actions/actions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_JEMALLOC=ON"
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