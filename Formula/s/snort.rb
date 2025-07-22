class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.9.2.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.9.2.0.tar.gz"
  sha256 "edf0aa5e72d673702bca161e235b7b8f8c3e5a49b81e8ddf2ea7e10736ab0cdd"
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
    sha256 cellar: :any,                 arm64_sequoia: "f6beeefc15b34f95451980dfbbba0b904b4f49374ec407f94683cfed2312d2f9"
    sha256 cellar: :any,                 arm64_sonoma:  "7d0733de40ddf3ccd1c2711f532d3a378c071106c2aab462494e1f8d82fe12d4"
    sha256 cellar: :any,                 arm64_ventura: "2a2fa9ebebb8f4d4f9c8a7cbec9d1e070866e22017ef0d49cdf60344cb20f7d2"
    sha256 cellar: :any,                 sonoma:        "56db22ab7fbfc6ba96aa2c7bea3ecfc822beeb774dd4c75d220ad346e0b7bcc5"
    sha256 cellar: :any,                 ventura:       "4bf95576cbab427a7617164471fe5a800c8f57c7a2f0aacd3bd3f3fc700330fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ba36b42c22a7f745c1df861c6fc7a8ca73eb687e70d227f3180833b4e37a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d299be44cb94ae6957388608c93baf09e18670d604086d7c061db75d9e0ae8c"
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

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