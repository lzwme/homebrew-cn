class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.6.0.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.6.0.0.tar.gz"
  sha256 "ea63805bb9275b407ed8c4796d914e9097dfb5cdca419828a569182313712117"
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
    sha256 cellar: :any,                 arm64_sequoia: "1189c2287f9e660edf7b691c1fb4101644dd3630a695757cf50ae506c9b85463"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c7c8bbb74511ceadf87f23ae200d27b2f2396407e7c0ed36aac3a7dc70bb32"
    sha256 cellar: :any,                 arm64_ventura: "0af545d57fe4a727e59d652cd68b33f28d9fdd83722e1fb03fdc909a13323051"
    sha256 cellar: :any,                 sonoma:        "5e4a1bc6159f1e1b81847c8fccec2d8d75eff1c4fea6e968e5ee9badff728e39"
    sha256 cellar: :any,                 ventura:       "d76d5666a309c39aafb106d4addb3108a245a0ff9773355a46af710c5c840c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf7998da6f3065a4a59bfe963544920ec8e7e782ce08fc3e8bb9517a38466b0"
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