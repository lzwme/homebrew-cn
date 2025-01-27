class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.6.2.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.6.2.0.tar.gz"
  sha256 "26cb2d06de9f9575e62087869fbb6fc52a409ce8cdf2da85c287e1f27e3da4d6"
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
    sha256 cellar: :any,                 arm64_sequoia: "eeb8777eb4fd44cf56e1cd58a3218a84b8fcb6e5f27dfc0768f651dbd0ad750f"
    sha256 cellar: :any,                 arm64_sonoma:  "e15fc053981cf465c217ed73fe7b9299277f918d48cf3c1fb267b037a0a79aa2"
    sha256 cellar: :any,                 arm64_ventura: "f59eaefbf5647000c475c6f1ae496bf0f13cb0fba4c3c8ae1c2859cb641d4cf8"
    sha256 cellar: :any,                 sonoma:        "36097c20dbdaa5e4ea76d54e1d1ed05e349e212a7b1ae72d5f312d3520b69d01"
    sha256 cellar: :any,                 ventura:       "be9ce39b4d8cdad5e3acd8792d985e3959f6b16cba72bb9c8955e331335a274c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f4f9acfe7c050ac356eed8061410d391ca9ea7de590cbc939018657795fb16c"
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
  depends_on "pcre2"
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