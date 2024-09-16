class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a236d73d50acdb76d566b71cf49b3699c4a5c41e7d5a9bd89eb4a2008075b37e"
    sha256 cellar: :any,                 arm64_sonoma:  "e1e434f0f9900ffb3ad4c9fd4d1604c21f0d91bc4c63a404ebbaa11d2fcb075d"
    sha256 cellar: :any,                 arm64_ventura: "59df08cc9cde588ffb7928316cb0e49de6f9ead0e58f0d720e73c003719306b3"
    sha256 cellar: :any,                 sonoma:        "5361c5f6b3551d101a0c4285551166bb6b099f2f3750b083bd08840a61b1c217"
    sha256 cellar: :any,                 ventura:       "5334b64428ad1b65b204bcfa193bdb8d12723a0cb815919af647fa8516a0ed4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c586516c49208fa490c84d210ce64b28a51bbe46aba78993228021c0676070f"
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