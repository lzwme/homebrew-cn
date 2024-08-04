class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.3.2.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.3.2.0.tar.gz"
  sha256 "4d37814404650582260d1a9e77eb5bfa907f8747b60c6898e0f38521b14df87d"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d83f4fe53a7faf42c846c50bc5d6373fa886bb055a56f6db53aa2da754eea4e6"
    sha256 cellar: :any,                 arm64_ventura:  "6d7f730df47562af6426d7ddcf1ce86cde3d976065defd134322dab54d7fbc20"
    sha256 cellar: :any,                 arm64_monterey: "b17d7573a34d5dad0e60fb18bc7025b5f7017e47a7d55f42f4506f692bb0a21b"
    sha256 cellar: :any,                 sonoma:         "742825ff02790c1272193ac0a5d41a67da4cd2a7a3c0b93ad95ff4450f2691f6"
    sha256 cellar: :any,                 ventura:        "82a5029d9ab6d3066b66f348d9f1a7dd9fea3327cac8137d9f3a2d0bbe14c759"
    sha256 cellar: :any,                 monterey:       "e276c92f0266658df97bb1fd589ce72522e335b839adad98b62c11b913edb594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82a6e951286f579dcb26c256ca01e2845ef5bb60ec3081251d978ccb47620cc"
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