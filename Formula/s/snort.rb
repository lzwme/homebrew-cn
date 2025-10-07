class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.9.6.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.9.6.0.tar.gz"
  sha256 "2335678bc5ff4f876dcdb6985407a5312b0f3bb470da29e2926f57f942ce3b94"
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
    sha256 cellar: :any,                 arm64_tahoe:   "65fd8262f1ac3eae7cdf85a9e24a755860adde675c59e963505373895fd45946"
    sha256 cellar: :any,                 arm64_sequoia: "13d6e20c6614326df0bf59cba4b88b7f79f520885ef9c78eb0dd0eba30f47bde"
    sha256 cellar: :any,                 arm64_sonoma:  "591b16a150fdd9946b65e9486c209e3d5c80721e6ce256b813a48e36d2c8796c"
    sha256 cellar: :any,                 sonoma:        "e63c2d35db9be41c6b5365db62521f7a94ef6e019082a761efa0700af0446b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85637efaa47f2d6d16e7bc2262df25a7e09930b5287f2ebd85b675f68e9bc86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc965f0ff111644a489558d03eebc1227e58f94f647da8409239cfa0b991f1f0"
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