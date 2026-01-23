class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.10.2.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.10.2.0.tar.gz"
  sha256 "5a7bad8c0c0c87ee12c74932c6cafbfb28c44abed4055a2862d222ff270a384e"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b5ea4ec2c944d022f49454ea08aea7e32faf0d3ed8cf459ed8a4f1ab08a3338d"
    sha256 cellar: :any,                 arm64_sequoia: "2f3ec7818592c46f77975bf34cb751c57358aacee480709fdd9ed1ed39d2ba27"
    sha256 cellar: :any,                 arm64_sonoma:  "90587667808a08737e8a5110de9842e2b63bd84894178e85553ee7ae4188b9c7"
    sha256 cellar: :any,                 sonoma:        "14e454a7b6f2d209671d9a64062dcae131ade36796ae00d3c07895a62808019e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5efa60d40bc98aa779f8e7829f5dcaca3cd90b24a9301baa13355c05f4898430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1586bfdd5322fb184ba798d9956e933fcb2510a2bc78ef18a1b9e6a56e9ddb2d"
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