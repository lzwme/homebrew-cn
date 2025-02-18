class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.7.0.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.7.0.0.tar.gz"
  sha256 "8c8b79cd4cc1ba51335cecd4797e5cbe032cbcef82f085b424128022054f0028"
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
    sha256 cellar: :any,                 arm64_sequoia: "ec2b112c4b705fa0f5216e5832acd4aa19998a54312d3e9f5998e69f14e1292f"
    sha256 cellar: :any,                 arm64_sonoma:  "a62f4eb6c01809adb40fb8fe72239b1cdb04479e65ce6157f226bdd55c69b3b1"
    sha256 cellar: :any,                 arm64_ventura: "e71277d696279e2e8ea0064de711820cd6d7660320524d29f777db68fb6b6a71"
    sha256 cellar: :any,                 sonoma:        "a7a1c8be3f3931938cd6360f34eeb0a39f7afa7d8809f0d2aee274cffe58f21a"
    sha256 cellar: :any,                 ventura:       "bff06f07bc0f4e3881ff85f5a495184d69c8a0d78f0100d57ec41fac4d913645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b1ba58bd89438eee2e1c59b538b58c5b480c025919ebfc09ec1c9c637c2a66"
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