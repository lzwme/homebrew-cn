class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 14

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "779080428f45d396f2dddfde202e9a301d84099b99a85be3b16fa549294c7e20"
    sha256 cellar: :any,                 arm64_ventura:  "31ee89bb0c80a418d5736ef51e7ebaa2f71636657590ad1d91ef2629ce84274a"
    sha256 cellar: :any,                 arm64_monterey: "f0ec266e63048e75071ec4235ae000f64093e3d993b57a63b2c374e0003c0eae"
    sha256 cellar: :any,                 sonoma:         "e7a2cbd2a608301161e2e3f17f9cb7aeeacfeb4f82f08fb24142ee48d138cc7b"
    sha256 cellar: :any,                 ventura:        "463b17b3e9975b1a92eb84e7446f6076d546e1840094bab0d6e04b2b6c5fcb5b"
    sha256 cellar: :any,                 monterey:       "82dd18bcd3062f1ce12a4279f50fce4ae386eae17029fc7b1a1489f381da978d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f501d94ea65283122626cad1988305c832d8a04eefa8e07625b1b1f29b82899"
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

    sleep 30

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