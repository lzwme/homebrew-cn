class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https:www.snort.org"
  url "https:github.comsnort3snort3archiverefstags3.1.84.0.tar.gz"
  mirror "https:fossies.orglinuxmiscsnort3-3.1.84.0.tar.gz"
  sha256 "dca1707a66f6ca56ddd526163b2d951cefdb168bddc162c791adc74c0d226c7f"
  license "GPL-2.0-only"
  revision 2
  head "https:github.comsnort3snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c37661810fda5a35e8e5935fa377a5aec79437b9cc5cbe939f1891729941482f"
    sha256 cellar: :any,                 arm64_ventura:  "c8f81cc4dad293f0475d2f311134a19ff3335cd6794bfecc4651eab3741ecda3"
    sha256 cellar: :any,                 arm64_monterey: "b11735411475cd32ca73e073bf327506ff531c699b42fcae24bd14136a1afab5"
    sha256 cellar: :any,                 sonoma:         "01f5915eeb3e5969011462376d7686c11ed12dc1d214249be327a2970ac282b7"
    sha256 cellar: :any,                 ventura:        "6b4e8571c260a327ac9db8c18ee730beb71be96c696c69ea91a6c9f83d1d2a60"
    sha256 cellar: :any,                 monterey:       "fb111731a19cb103132216c9de1c5f83b0b94ac68f1ec8aa0853bf7fc314e71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4493499456f14e04cc03480608e48fa7fa0cfa8e865e25a7d65ebf7c72111579"
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