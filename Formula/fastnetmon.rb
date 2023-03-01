class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://ghproxy.com/https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "72f364ff5557afe5670bb9444e975841bf2c2db4eb13d2425e5d2903ca8fcf22"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ee48fc8bca98b3ed63d7e274ea4777262f2d6da396d592d0973f74067081ce3"
    sha256 cellar: :any,                 arm64_monterey: "7d8077091e264717aee8cc4f22261eea1fd06ef02fd4c10a0fba877225bdcb2b"
    sha256 cellar: :any,                 arm64_big_sur:  "2a3c50986a8408b7305803d5cb8c4ed875bfa26d62c4bd0fb6eb64f7779f34bd"
    sha256 cellar: :any,                 ventura:        "89f5b1f326dbe8f024c95df2c22bf46f6ad06336fc0dfd5273d959c04b086faa"
    sha256 cellar: :any,                 monterey:       "c8c6c7b64e41d7d89f42466902d97e3f12e0e4ae45b0ded1d96355a99c0176ac"
    sha256 cellar: :any,                 big_sur:        "35b57caf222c9ec1acab2780c6f504fb1be6b654ad44b3e5778a4d67c1323a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1fc3c9d22c92b59c6460fdf4d9e8647e458faf6bcad5edf3a59323b64e3395"
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

    patch do
      url "https://github.com/pavel-odintsov/fastnetmon/commit/c48497a6f109fc1a9f5da596b055c3b7cffb96d4.patch?full_index=1"
      sha256 "2e3eabf7727e12d2f1d57f1db84d1272468abd67989cc8d9a8624035c36aa8c8"
    end
    patch do
      url "https://github.com/pavel-odintsov/fastnetmon/commit/c718e88d0b25dcfbd724e9820f592fd5782eca6c.patch?full_index=1"
      sha256 "bd7e7e1de406b0918a192dcc8a058e82bee4195c3f00157902f0c998f9b3d0e2"
    end
    patch do
      url "https://github.com/pavel-odintsov/fastnetmon/commit/3b912332801c85dd5840cedb6bb248a339056187.patch?full_index=1"
      sha256 "bbdbfed272efcd05959479636857c89721379ec5585f5e5ff8a1523e1b32ee1d"
    end
  end

  fails_with gcc: "5"

  # patch macOS build, remove in next release
  # upstream PR ref, https://github.com/pavel-odintsov/fastnetmon/pull/950
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/b3895208c9aab27881c97e1181e7622ea3ea84b0.patch?full_index=1"
    sha256 "8ee473b8b44765af6ad5bb9e9ffec7cb6b47bec196fb96de12f21bf890f778a1"
  end

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