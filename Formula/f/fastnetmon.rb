class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 17

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc05ea60c03e6db29af977a62bcd3e5947094e17597e10f241457c1dd6aaf003"
    sha256 cellar: :any,                 arm64_ventura:  "25f5a6563261ecbc89f5c054e31f0f5ab6c9ee2db35343a99940c4cb66d640e0"
    sha256 cellar: :any,                 arm64_monterey: "f9a0a5f0fe94b78c2578f38d2e3c838b0c07f8ef206368ace0c8520b06df4cf2"
    sha256 cellar: :any,                 sonoma:         "2624f8000fad19b65288a580a125a39a30648309a6f5b174a1847913b6892e37"
    sha256 cellar: :any,                 ventura:        "e69f494480f6ea155928c246c543a36292708a8fc8540c6df78c29d0e70a281b"
    sha256 cellar: :any,                 monterey:       "d8e6fbc5e2576570e74e78af10d9f555e61acfe36ef1410bedd5fd7c3982d35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6ba35da30b7842099f58f3cb3c5d85d029213afd087d4853f6a39831f098ab"
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