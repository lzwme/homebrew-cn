class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  # TODO: Check if we can use unversioned `grpc` at version bump
  url "https://ghproxy.com/https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72b0f827d077d7010b154ec7c1e552d1fb5d9d929dfdb9228b4e20c9d7c0a5b7"
    sha256 cellar: :any,                 arm64_ventura:  "7aacf6920bb8c643106641104ed305fe405e2eb13219925dbc970685b20b7591"
    sha256 cellar: :any,                 arm64_monterey: "3473816d371af956a3ba4e7b1d49060089b97a7a8705197764d8b0b675ff5ba5"
    sha256 cellar: :any,                 sonoma:         "491f31bd95ff93fc96125eeb8051e2ee749d687466a5e19d6537d1c9c8532b43"
    sha256 cellar: :any,                 ventura:        "3f1c97462bd6186a3b84e504af2bef8c56d530d7f325b10f541d57e7a6460e31"
    sha256 cellar: :any,                 monterey:       "0e6c9204a6944283940f986703e8eacbe5dfdf04a875b52c65a264a8cf243058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2cfae036fee7682cee8a74a0af58dccb5525b0ef2704c8c3c3792ee6bbe200b"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc@1.54"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
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

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon.dat", (testpath/"fastnetmon.dat").to_s

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon_ipv6.dat", (testpath/"fastnetmon_ipv6.dat").to_s

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