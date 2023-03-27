class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://ghproxy.com/https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "84cd5db0e270f6c268923592eabd5cb0d1689293d9d9f6f0634af548b29f9bb4"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "23fc7d480eff73bca7de3c1c76c8bf8fd6818e64702ea1c8137c979d54391331"
    sha256 cellar: :any,                 arm64_monterey: "9cbc72a618f520f9bb4abf1f1db8bb12284ce57cc438edaad80b3ae95be7b468"
    sha256 cellar: :any,                 arm64_big_sur:  "7b3d612544afad9701d371f2402ece3ff22331f7d625ae9b83921e78b7d92cb6"
    sha256 cellar: :any,                 ventura:        "88b4529a8a7555ecf9d56ce599be5d2dbcb5357f43de6a3ff975ef3971afd405"
    sha256 cellar: :any,                 monterey:       "28706df7d6dc8fa3cc7c612a88bb473f530b34bd514229aa1a06ed04024c7fb2"
    sha256 cellar: :any,                 big_sur:        "8b4e728fff747e420324048363c7fa5be36566532b01970e8a125d9ae9028dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e30639b46dc1e5fd0f9f4fb55cca0b47c85034438d0eb11a399ba18785fa2d2"
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
  depends_on "openssl@1.1"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
    depends_on "libpcap"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DENABLE_CUSTOM_BOOST_BUILD=FALSE",
                    "-DDO_NOT_USE_SYSTEM_LIBRARIES_FOR_BUILD=FALSE",
                    "-DLINK_WITH_ABSL=TRUE",
                    "-DSET_ABSOLUTE_INSTALL_PATH=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [
      opt_sbin/"fastnetmon",
      "--configuration_file",
      etc/"fastnetmon.conf",
      "--log_to_console",
      "--disable_pid_logic",
    ]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path var/"log/fastnetmon.log"
    error_log_path var/"log/fastnetmon.log"
  end

  test do
    cp etc/"fastnetmon.conf", testpath

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon.dat", testpath/"fastnetmon.dat"

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon_ipv6.dat", testpath/"fastnetmon_ipv6.dat"

    fastnetmon_pid = fork do
      exec opt_sbin/"fastnetmon",
           "--configuration_file",
           testpath/"fastnetmon.conf",
           "--log_to_console",
           "--disable_pid_logic"
    end

    sleep 15

    assert_path_exists testpath/"fastnetmon.dat"

    ipv4_stats_output = (testpath/"fastnetmon.dat").read
    assert_match("Incoming traffic", ipv4_stats_output)

    assert_path_exists testpath/"fastnetmon_ipv6.dat"

    ipv6_stats_output = (testpath/"fastnetmon_ipv6.dat").read
    assert_match("Incoming traffic", ipv6_stats_output)
  ensure
    Process.kill "SIGTERM", fastnetmon_pid
  end
end