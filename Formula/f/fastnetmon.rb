class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 15

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f405f7b308fe784d174e1f95bdfeff527ec51b42b40595f1d8ed65b617374860"
    sha256 cellar: :any,                 arm64_ventura:  "0001773ac1f0eb503eeea8089c81666930a03d442de18b1a31bc1528539beedf"
    sha256 cellar: :any,                 arm64_monterey: "b57d3513b792fc5318f31f40b3b74f092fa8b996183af0aa9c814960dc864dd1"
    sha256 cellar: :any,                 sonoma:         "b23511119cb5af7b69a66450024461a53c847b4c009987159d1595867eef6598"
    sha256 cellar: :any,                 ventura:        "4ca451f62630e9bd1b3e7472434a6e73d5ad44c7947a00dd8eb61a758193e46d"
    sha256 cellar: :any,                 monterey:       "c13f489be5077f749e37d4f6596db97e66648d8bc71be146fa0ea71d2793286e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0b89a773a0fbff00587dea91f56acf814f459cccb5948294b1baad1030ab45"
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