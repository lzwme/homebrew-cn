class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4a12bed1436986dbd2613a0de9c16079edb2078fc6ae1916d79c9bad1545f32"
    sha256 cellar: :any,                 arm64_sonoma:  "0a7b03aa4587a7938c7d94fd7311042bf73117d00cfe2fb4075b425dd6df20f0"
    sha256 cellar: :any,                 arm64_ventura: "c7fd7de982e4c400459377296ec83d3891f9378f4df50c2b226b2489217aa8fb"
    sha256 cellar: :any,                 sonoma:        "e94108dd878b81c61aac0b7abf695e471134675785e59ae509da10fda4ab06ec"
    sha256 cellar: :any,                 ventura:       "9c02a82b459eb9c5e32b63a50cc2e335506e9a3398772d51e594667fac523bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482b6e7bae80663b33eaa87da4cfe946be4d639128822f1bcb7d575dce2b4978"
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