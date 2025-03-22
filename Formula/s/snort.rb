class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.7.1.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.7.1.0.tar.gz"
  sha256 "3bb7a573e46f47f7be9e37dfe1902c43b9d5a9a5abd4d30282675a37089e518f"
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
    sha256 cellar: :any,                 arm64_sequoia: "3f1b0ad8e5f6d1d4995ad50dc8cd952a4f0f1dd464580e2521f6da896665f9d0"
    sha256 cellar: :any,                 arm64_sonoma:  "b02cf0fef97e3e2db3a58f91ef18715882ad8c71168d2efd407ad730528bc3ab"
    sha256 cellar: :any,                 arm64_ventura: "2b7b5e26dd4eb77456c4c35fdd7c7275096a3c56e5f1b982f7758d5ccbed9e04"
    sha256 cellar: :any,                 sonoma:        "ef9d997a60c53c81e1bdb047ee31bc520d874bb8dccd81b87323f7ca4cb41283"
    sha256 cellar: :any,                 ventura:       "9029b231681ea831d1d715092f66197b61486dbe193ee64f1722bc71e346390a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b83789ca77266b8cf0941699104131d7db78e73889bc0fe292953566ccafd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfe8e38d0509eb07a9a1d9ae525bf20d71cdeff137fe856a0da995ad3a3c05d"
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