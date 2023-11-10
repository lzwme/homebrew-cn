class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghproxy.com/https://github.com/snort3/snort3/archive/refs/tags/3.1.74.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.74.0.tar.gz"
  sha256 "4a4529e74bc202303c0330ae8b2317f0bef3ac92ae7216df8cfedfce24ddd129"
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
    sha256 cellar: :any,                 arm64_ventura:  "caaeb592c46c762b2f1c5f5e80404f8b58fbbf3131ee2829a166ea6ef835f63b"
    sha256 cellar: :any,                 arm64_monterey: "630fc011870aaa0e2bf9a543447890a2c2793879694a59b587ec682e9b57ba06"
    sha256 cellar: :any,                 ventura:        "5ebf79f0aa6bc1ce36637a35746a8a208186e7c937649b8145ca5b513e278866"
    sha256 cellar: :any,                 monterey:       "8d163fc73ed2e655a3d88c5a7ddea548c41914c905fe72b7efbac4029692f833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d346c8dca54a3e9a58ecd223336bb3322d3de1c5a9af281c53a77cf8e25fe898"
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