class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.11.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.11.1.0.tar.gz"
  sha256 "9465d19b0925088266504e8962e97e55359bafd6a19f66b4169dcd21ef1d8ec5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "177d8367bd804e840b652dc80456c60fbd0fc36de2dec314c237f6dc63f9051a"
    sha256 cellar: :any,                 arm64_sequoia: "b903c3400cb3755afb8106fc2db4602021ac30d07b0f9ddd22e39152e516c6a4"
    sha256 cellar: :any,                 arm64_sonoma:  "77f4d9d73697341aab981f275d2e995cbdd5548716ca88d8836afb26357735e7"
    sha256 cellar: :any,                 sonoma:        "c08a26e8c78cd44ea33713777630d0aecd8e54dd081ece075fe8408083c29fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d611cb0f3e8dddbe82d7014d246da1ac49c7b1d04109c74ebee550d30693cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf72acf3710c8cd48b1e88606e59bfd1e87645147563831ec5fab7614f0263c6"
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

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
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