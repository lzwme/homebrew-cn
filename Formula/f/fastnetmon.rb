class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed2df3b910741df379ba2ae5078e7365cc3bc30676a89e265b669a5864ebd8d1"
    sha256 cellar: :any,                 arm64_sonoma:  "a894c1adb691d0f044e94b4bc31ba4900b4c2ae0f84b4a55c2f621a68ea2ac81"
    sha256 cellar: :any,                 arm64_ventura: "ad79e1622ec14f1ee0b74ef15214110e362d1f7b7e35123fe6220fcaaeaf4e49"
    sha256 cellar: :any,                 sonoma:        "b9b52ca7328304e9948590301850eaab0083b8b4dc47586648f657b6d97a4385"
    sha256 cellar: :any,                 ventura:       "3515079d9ab03c0d7e2fd2435d4c92808d2519a3872d95e8c310c4a65573eae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eea1c1ee9e69723a710186bd69900a85b50c3330ddf19a4337694017e7fee34"
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