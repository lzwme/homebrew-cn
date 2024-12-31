class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.6.1.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.6.1.0.tar.gz"
  sha256 "aba1c8d1dd099bf7abfeac7f073413ce4b6bd527d8ecaa92aa47726c753c3a89"
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
    sha256 cellar: :any,                 arm64_sequoia: "d7bd66b401bceb3caeb5bbda60946ee009691f6b0484232fb76a1d687d07cfa2"
    sha256 cellar: :any,                 arm64_sonoma:  "a567d082e09c81c64eaa5576793291cac50c8fc3a11e21b146a92a6a93c82ef6"
    sha256 cellar: :any,                 arm64_ventura: "2d2d9bdf176831fa28bd4b373b7efc77a5785aee4a73ac05d5d09f70fb3bdc98"
    sha256 cellar: :any,                 sonoma:        "caaf853abfda911109b20997f2c50bdbc5fab27ce6736bd513be4b6687a4ec83"
    sha256 cellar: :any,                 ventura:       "8493270ce84dfe671011d1c218aba7eb0d4e92aee00080c9c6c150c5fb8f8188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be018499e0f606d7741574019f56d348207a719b81d39cc6cd1aa24d6bfecbf7"
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
  depends_on "pcre" # PCRE2 issue: https:github.comsnort3snort3issues254
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

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