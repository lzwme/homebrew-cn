class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.3.5.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.3.5.0.tar.gz"
  sha256 "b87f5db610d869c11769d795c6cce7646baa930d6ba2509460add28cb4a028bf"
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
    sha256 cellar: :any,                 arm64_sequoia:  "8292b9ee920bc9275b1b23120b6dfcb39c9617d780c7d876a8bf1e383858bc3f"
    sha256 cellar: :any,                 arm64_sonoma:   "a6afcbd8b1989ad3a7e7c0ea7587e3f3b5feccc91756e8d70f9a912a529195cd"
    sha256 cellar: :any,                 arm64_ventura:  "93f11503d4a9a0f654edd6fbda94df865362db9451a940e66565d864a5e61c64"
    sha256 cellar: :any,                 arm64_monterey: "df59e5a42ffd8d0d4dfc140f7128eacfbb1f418bb78c005233abeb702b7d1792"
    sha256 cellar: :any,                 sonoma:         "0aab11a6772cead9dd186ea202de9dd77ec0ebf12da8cc01cd71b44cc89fb0da"
    sha256 cellar: :any,                 ventura:        "853271d5b6e11457c07373cb071ca9694d83cdf37c70004586b810ac6259890d"
    sha256 cellar: :any,                 monterey:       "2c8056fecabd46b0080c607da98e11cba2ed9e1b4a03b6af6eee3004ab6df5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "459d1913c00dbfea7bf67b0918deed83a3eb17346e6c44b8e7c4b3a817cf633c"
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