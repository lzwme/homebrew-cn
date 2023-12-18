class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.1.76.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.1.76.0.tar.gz"
  sha256 "5586199be8b7a7c6a1b73e0af2e2e004db8417b8282668b10583071e35c9c7a9"
  license "GPL-2.0-only"
  head "https:github.comsnort3snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6382a1ce05d144ea808eac9ba0d4ef4b07bf25df79f05713e183b36484c80cfb"
    sha256 cellar: :any,                 arm64_monterey: "08f82c6bdb6fbd77a8e3dd4388a441f621858975fbd40bd298a2b993df35c0c0"
    sha256 cellar: :any,                 ventura:        "6d3ed72c89ddeb7f1760f5dbc031cec4acea9118e044a8a5bd569ba4f314ca09"
    sha256 cellar: :any,                 monterey:       "e288bfc58198ebdbefd1e30633c5bf1e92030284245817e65943067a1aad0bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d048ff2cfeb3601ff447c8a40549d8a59277cc45b90efeb1b2acfedc2deaabc4"
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
    # These flags are not needed for LuaJIT 2.1 (Ref: https:luajit.orginstall.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmakeFindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      For snort to be functional, you need to update the permissions for devbpf*
      so that they can be read by non-root users.  This can be done manually using:
          sudo chmod o+r devbpf*
      or you could create a startup item to do this for you.
    EOS
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}snort -V")
  end
end