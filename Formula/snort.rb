class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghproxy.com/https://github.com/snort3/snort3/archive/3.1.58.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.58.0.tar.gz"
  sha256 "c2b37899db42e2db9a05089abbe0ba48633c6c48496d2c64565500b4f9061d78"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cd7b1535149373f7c410744a5130780004d302f935987e2ef1800e85f0e56976"
    sha256 cellar: :any, arm64_monterey: "1fd84497ac979eef4be7b6a35e03760314a3dcd585e1e10a458c399cf49691bf"
    sha256 cellar: :any, arm64_big_sur:  "1d34c400df01493dae6aecece1f5993bda6f5e4d38f48f302f1e6e4e37aab41f"
    sha256 cellar: :any, ventura:        "a89c5baccd71c7f784f56aa6dfe52bf64a02f6fc35dcbf13b75d124cf1088e7c"
    sha256 cellar: :any, monterey:       "8e120aaeb3f12a9b5fe9d775d8671878db3b421e60737c727e417b5e8b54fdfb"
    sha256 cellar: :any, big_sur:        "a01e52ab82ba084490a89a7e9fbbfb4168e61ad30abb047527f70a2992fa212e"
    sha256               x86_64_linux:   "d3312e4e707d034c032a28952b71b30b0a40da74f0822cc11e3e4b22035a0a22"
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

  # build patch, remove when it is available
  # upstream PR ref, https://github.com/snort3/snort3/pull/286
  patch do
    url "https://github.com/snort3/snort3/commit/02e60e50d1a4a18d27643d5f4474bfc0c4709e14.patch?full_index=1"
    sha256 "25fcf002f9613a1fcc06127c72ed2315c93580a6da2c0afd2e82e081f35dd9fc"
  end

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