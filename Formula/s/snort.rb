class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.9.3.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.9.3.0.tar.gz"
  sha256 "c7c2f7488b1a9ec5b60b9706fc3f2f3f9c0e1eb57f384e077676c452570468cf"
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
    sha256 cellar: :any,                 arm64_sequoia: "ec948bb338edc8813cd6cb1c2c0c2954110bd6b5baee8e9b3cbbb3231e3f7bb6"
    sha256 cellar: :any,                 arm64_sonoma:  "2e596e2e83f55eb23346c1439c7fb971f2dc813a3d40f3ee54892d68427af576"
    sha256 cellar: :any,                 arm64_ventura: "933b11f317a73448395999a45ccb843270d6dc7ad700b7e5c36b6a5ee5c0a175"
    sha256 cellar: :any,                 sonoma:        "31591da6b2b2922b6ad80d40f68eb2784532305e94c85e51d25442e51ef04221"
    sha256 cellar: :any,                 ventura:       "a15320864eb7ba13c9a1ed496b17cae09219cd9d522c0023bbc8c3ac0b1e717f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "487cb1b754cee1bd9d52748408117f071c8e9efa42cc7a8d22749be56d4fbc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22574b8562a0b421c8f882547e54ae34b91b9518d947a3b83d521d1ace724adf"
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