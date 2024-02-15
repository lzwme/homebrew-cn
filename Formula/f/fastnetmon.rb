class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8b864480fc12d54a2fcc5294777a6bf9e72c8f55b36f3f35aceddfabcb62164"
    sha256 cellar: :any,                 arm64_ventura:  "e78783d282c0cfb7d5651248bc4374b61eb04e7b867321cb572dce9d78ba3f72"
    sha256 cellar: :any,                 arm64_monterey: "d5a6e493f93aeb40cbc8d52bb6319096f39f96047c31a72c89b10a1406070023"
    sha256 cellar: :any,                 sonoma:         "bc3cee0cd731ee4cfe16697e8beae06cc0764874b6dee26bcdb8bda8827a6e02"
    sha256 cellar: :any,                 ventura:        "d2c90bcd28a7d7aba5762a74d8351cba17c9a56fdc9cd3ee96220408aa784b45"
    sha256 cellar: :any,                 monterey:       "b3b9b92b2edd94eebb33dd0e31f8c9d3c997f73018d8288c36e6638cd3f2c796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db774483ad93053c9f6f5d4b1241013adc30c8dba0fa1e3bc1b5c1e5837b3ce"
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