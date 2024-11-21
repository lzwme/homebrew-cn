class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.5.2.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.5.2.0.tar.gz"
  sha256 "5d06bad2450799b6ab8e3d1a5acbde2fb199b8da9d7abc155ff6c4dd24d7887a"
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
    sha256 cellar: :any,                 arm64_sequoia: "243300cfb95dd691cab1e5a157465f33dca59ed9bf2a89d402452b5e71945644"
    sha256 cellar: :any,                 arm64_sonoma:  "4ccdeb4545d8347f0501235eba8d243ae3b9f25f6a8adc68ec97888378afb8e9"
    sha256 cellar: :any,                 arm64_ventura: "180ff6c5ca84ed9a39d3d82cf6254326f817790dcb20a2aada41b278c513772e"
    sha256 cellar: :any,                 sonoma:        "3482ed990a4fdab9d74b3c65c4b1cac70992552da1e42cce2dfe4d1e36852d3d"
    sha256 cellar: :any,                 ventura:       "5a643513efa56a498a77037886927d2cce006324ae87a14ac691325f893a4ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe64091977e3d429b299f843a20f81519a28752d141092ef0f427eaf436a92b"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https:github.comsnort3snort3issues254
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https:luajit.orginstall.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmakeFindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https:github.comsnort3snort3pull370
    inreplace "srcactionsactions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_JEMALLOC=ON"
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