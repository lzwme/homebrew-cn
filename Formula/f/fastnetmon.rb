class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "251b1c74ebe1ab6a06edca362a9103818205dbd07c364d4fa6da6957beb40bd4"
    sha256 cellar: :any,                 arm64_sonoma:  "db7e96d311621d69a9742d982c05f8c3a3a17d8a6ec2b6d6801cdb877121c674"
    sha256 cellar: :any,                 arm64_ventura: "e13b525a79b69508fe8905e50e0e372b1e861b1d7c3f3ca193e4bfdc7384c4d2"
    sha256 cellar: :any,                 sonoma:        "34fd2413e1845d617aafcb534ed633ccbb65483c421e78ad2c7b8f9277b2a0e7"
    sha256 cellar: :any,                 ventura:       "2fe2a635ceb7a2accb83b0abe3d391918ec1480715775254f24444b8528457a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf131d906cbdab938fac243fa957329f8648adb0a2960cd8a2faab303dd97f10"
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

  # Fix build failure with gRPC 1.67.
  # https:github.compavel-odintsovfastnetmonpull1023
  patch do
    url "https:github.compavel-odintsovfastnetmoncommitb6cf2e7222c24343b868986e867ddb7adad0bf30.patch?full_index=1"
    sha256 "3a3f719f7434e52db01a512ed3891cf0e3794d4576323e3c2fd3b31c69fb39be"
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

    sleep 60

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