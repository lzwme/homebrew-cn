class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghproxy.com/https://github.com/snort3/snort3/archive/3.1.66.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.66.0.tar.gz"
  sha256 "4481f882d767620e91fa6d97232ae9527cab06ba77087399c5dd91c72826e0bb"
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
    sha256 cellar: :any,                 arm64_ventura:  "bb087c1925238c7b8f29a7175d546fd3b168943041f74b752a51d956216d1f29"
    sha256 cellar: :any,                 arm64_monterey: "a57cef6c9f346ac48ee87336c9f5c1212d312b6cc3b486e4ee4632a850c5389a"
    sha256 cellar: :any,                 arm64_big_sur:  "6d1da79f8667200c291ce3dfd79a20c6d6f8dafcd79713d61d8ecc3ae9232230"
    sha256 cellar: :any,                 ventura:        "83fc3fa531430c28c607a1b01cd486d3d7df569d1ec2cf900430a00f0d54666e"
    sha256 cellar: :any,                 monterey:       "6a861eb977bc1cff123f8d7b4e315381ffbcdc9b84305692dc7e032bc6298394"
    sha256 cellar: :any,                 big_sur:        "15bb07f7e6b5d22e2ba40164771e1afbf0768463fcfe4530c2bfe23b95efd3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b9d40ca5bb09e3646837d855ea68260ef6da51337a9fc1b94f8f0233eb5d83"
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