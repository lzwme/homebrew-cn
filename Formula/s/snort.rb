class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.5.0.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.5.0.0.tar.gz"
  sha256 "212a9b4c1852d5c84153c2e776ece6ae617435241020329d4fdc27ac23965e3a"
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
    sha256 cellar: :any,                 arm64_sequoia: "efbef34365e58ba63391e393dbd560ee57c3d7a883817dea54850f47f2b59fbf"
    sha256 cellar: :any,                 arm64_sonoma:  "c1b5061c1c003d3bbbd4f56001c681fb0e55b535e0d46247db20582709d6f00e"
    sha256 cellar: :any,                 arm64_ventura: "9dd28d2238b7da35c8f8b7fc6a44862610c7a3a4689f59dd4c5de9f77d5a8966"
    sha256 cellar: :any,                 sonoma:        "58fbc2fe762634282403d2c60ca9390e0da0353203666405f49f109eca856ea2"
    sha256 cellar: :any,                 ventura:       "4cf3fa11bd69615cc333ffd71402e593ffe67ab0d3f36c83434b142639174845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3714938ad0f7af4d1462b2dc5e7bcb1083981597a41f6305558f890380c26900"
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