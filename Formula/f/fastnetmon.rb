class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "264d2413d54810f202dbca3552b968da96dd12395944bd6189910e9b137cd1d4"
    sha256 cellar: :any,                 arm64_ventura:  "8baa3bd9675bf8e0276654308e4e35b7cb66c22bdbea4b0a4ec74564e9d2936a"
    sha256 cellar: :any,                 arm64_monterey: "9afefc4c7bf74df009afad6768766c015a5b89d874dfec0fcd0487482131f987"
    sha256 cellar: :any,                 sonoma:         "09c37280413c23444b1c5dd6172f1a9926db68f95fcbb8985eb06e7f441d12f6"
    sha256 cellar: :any,                 ventura:        "52c65915690273ab0f13a8c001410cb515e8efc3f09a15a417dd0ea96e073c4d"
    sha256 cellar: :any,                 monterey:       "a1eac03caee1c0eec4e5f6e69c3394ffec4a6b785f0b6a834a832b1b124e00c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc448d40737998951a06a1d3d96db9941b3c0383023a9e7b1c2298d71b617af"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "protobuf"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
    depends_on "libpcap"
  end

  fails_with gcc: "5"

  # Fix build with newer `protobuf` using open PR.
  # PR ref: https:github.compavel-odintsovfastnetmonpull997
  patch do
    url "https:github.compavel-odintsovfastnetmoncommitfad8757b8986226024d549a6dfb40abbab01643e.patch?full_index=1"
    sha256 "2da8dbdf9dc63df9f17067aef20d198123ce1338559d394f29461761e6b85f85"
  end

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DLINK_WITH_ABSL=TRUE",
                    "-DSET_ABSOLUTE_INSTALL_PATH=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [
      opt_sbin"fastnetmon",
      "--configuration_file",
      etc"fastnetmon.conf",
      "--log_to_console",
      "--disable_pid_logic",
    ]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path var"logfastnetmon.log"
    error_log_path var"logfastnetmon.log"
  end

  test do
    cp etc"fastnetmon.conf", testpath

    inreplace testpath"fastnetmon.conf", "tmpfastnetmon.dat", (testpath"fastnetmon.dat").to_s

    inreplace testpath"fastnetmon.conf", "tmpfastnetmon_ipv6.dat", (testpath"fastnetmon_ipv6.dat").to_s

    fastnetmon_pid = fork do
      exec opt_sbin"fastnetmon",
           "--configuration_file",
           testpath"fastnetmon.conf",
           "--log_to_console"
    end

    sleep 15

    assert_path_exists testpath"fastnetmon.dat"

    ipv4_stats_output = (testpath"fastnetmon.dat").read
    assert_match("Incoming traffic", ipv4_stats_output)

    assert_path_exists testpath"fastnetmon_ipv6.dat"

    ipv6_stats_output = (testpath"fastnetmon_ipv6.dat").read
    assert_match("Incoming traffic", ipv6_stats_output)
  ensure
    Process.kill "SIGTERM", fastnetmon_pid
  end
end