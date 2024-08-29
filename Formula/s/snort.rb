class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.3.4.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.3.4.0.tar.gz"
  sha256 "dd6d18c231a424c4e8aa18e1a3ec12740a9d61520cb356826aa9972699dbabda"
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
    sha256 cellar: :any,                 arm64_sonoma:   "634fce695946b7403da03b9b179aa15a69fc19846734b95924af015ce4e759ea"
    sha256 cellar: :any,                 arm64_ventura:  "50cd21e3525e1497b67a441303be4ed797a74fe79b421849749f4b721407bde6"
    sha256 cellar: :any,                 arm64_monterey: "00b9f0b8360dac048e3ad347536cf1b2523ae4dd39855276bc652636328f812e"
    sha256 cellar: :any,                 sonoma:         "84d5ef23cfded4dae322c076126c98ba489d7753415aac2f835dd059a9088e84"
    sha256 cellar: :any,                 ventura:        "f88f097cb7e59bf637e34073ef1343100e47af524c67a64c4a4bbdce3185569f"
    sha256 cellar: :any,                 monterey:       "e49b26705238fad182b1db208615b2d6cff70f65017f14458da9f8717ac94c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e08b6ffdb009dcb35d1f3a0f1ea9118c792be545f97501bd0f71685dc0c87032"
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