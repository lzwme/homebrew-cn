class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.1.77.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.1.77.0.tar.gz"
  sha256 "cb98c0d15caa7c84da24995e8521f42f4e86a860b9748418154d8649b6a0db2d"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comsnort3snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ee62163a6bbfac6ccc2edda38a4f7bcc94665f2a18f42c630b01f139bc319f4"
    sha256 cellar: :any,                 arm64_monterey: "7cf51f990bf27a29e8316a38246b475d36bb3f4126c995d7aaa1623a0e011d97"
    sha256 cellar: :any,                 ventura:        "24f7f045a33b6ee32801733fd66ae874b063cf2e496d7d16ddf57d18fd618e3a"
    sha256 cellar: :any,                 monterey:       "10f0ba3e1479bbc61a2dd33dc18120233e0466bf603e77cf34ab5ae3830cd142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da053adcd3d55361cb6f41a79b09e907b79743259e6056bdcd3497716b50fde6"
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
  depends_on "pcre" # PCRE2 issue: https:github.comsnort3snort3issues254
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