class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://ghfast.top/https://github.com/snort3/snort3/archive/refs/tags/3.12.2.0.tar.gz"
  sha256 "43000d6b0e0307bc1a735874d00deb61e8b6a96d074f8cc9b2fe2cde0058720b"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "dafe7c135cd7c22279f55dbb65e7271f23d58abb57482418790d9b2c9bb11bf0"
    sha256 cellar: :any, arm64_tahoe:       "7c7c722c4743d25cff27ccbea3a61b8a3ace36d0e75a95f3c64248ad33095c1a"
    sha256 cellar: :any, arm64_sequoia:     "1337f6bc8f092a84d5655a8bd93aaa8dbcbb3f2d0667c9d093fe600e1a77b7a6"
    sha256 cellar: :any, arm64_linux:       "59f654ffd81a9cda1d350aa318e80ae4836038f0a6c9b0ec6169983696879140"
    sha256 cellar: :any, x86_64_linux:      "93bdc4b78bf8709e3877f32d4d6250af5a435f883ed5fe6403b945e32d2b3b42"
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
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  # Apply open PR for OpenSSL 4.0 support
  patch do
    url "https://github.com/snort3/snort3/commit/286352b0e3f3e0798666d4f78ca35668d8695ab5.patch?full_index=1"
    sha256 "8707359cf1854a85bf7f48e8e8b5a949739e0965ee55078bfdef033055971fc7"
    type :unofficial
    resolves "https://github.com/snort3/snort3/pull/477"
  end

  deny_network_access!

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https://github.com/snort3/snort3/pull/370
    inreplace "src/actions/actions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_JEMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      For snort to be functional, you need to update the permissions for /dev/bpf*
      so that they can be read by non-root users.  This can be done manually using:
          sudo chmod o+r /dev/bpf*
      or you could create a startup item to do this for you.
    EOS
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/snort -V")
  end
end