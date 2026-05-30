class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://ghfast.top/https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "d16901b00963f395241c818d02ad2751f14e33fd32ed3cb3011641ab680e0d01"
  license "GPL-2.0-only"
  revision 31

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2891895d1788a8196bf9c2b73d0ff5c7c7d26fb6e53123ef6dcc729c38b27c09"
    sha256 cellar: :any, arm64_sequoia: "abccfe25ac5b9bcf9438e64347daa2c008283984d87030c2b2b0283d97e83fd9"
    sha256 cellar: :any, arm64_sonoma:  "011019255779c3b0ccfb475222b48bd8c1b29c10bb9755519cdf39b2d5ab4661"
    sha256 cellar: :any, sonoma:        "88f1decdb601bee9f396e98404a4d1e979a65323f799b853387e6aaf6bf14c5b"
    sha256               arm64_linux:   "ecbb2fd03611036a2fdc7b948ddee7ff6d6f0642d286191f8c584b032dd47b57"
    sha256               x86_64_linux:  "d0e3582ddbbd0ca95aa90e9a95875a38726edd0dfa55820fc826b2b08e90bd14"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "protobuf"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  on_macos do
    depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  end

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
  end

  # Backport support for Boost 1.87.0
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/f02063204d2b07a525d70e502571b31514653604.patch?full_index=1"
    sha256 "273d22bdfae85e464ab8cc1044423b2589800bef1db649f664049030f2cf719b"
  end

  # Backport fix to build with Clang
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/8a91b5a8c8be1af0fe96ffe1ee1c002c30494662.patch?full_index=1"
    sha256 "cb2dd41177c73ed3ef4ee3a372d8f99b6471f695041dc1c05299ea03a572a202"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/pavel-odintsov/fastnetmon/pull/1038
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/4a526e90d5b493265ca2e7ffcbcdbb6ed10f064b.patch?full_index=1"
    sha256 "d879800c448a08cbe312ca5c83edfaacffadb0a74f57707240a31316275abc6d"
  end

  # Backport support for mongo-c-driver 2
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/187ef0c9d0fd7f86f24c70b5233635eecc5943cf.patch?full_index=1"
    sha256 "30517a7eb3a07ad1aa324a6f6a31adc8d1ff936fb7ef1d0459efd1190432da65"
  end
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/1ef41391c7d816e9d6105271b847c68593cb4a1c.patch?full_index=1"
    sha256 "e0e74b52906c3fb91ea0627a3d72d95ae6f2008ac14f969e609a754321015218"
  end
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/943d8707cea1622aa20837a232a429277acdd0a7.patch?full_index=1"
    sha256 "5312098a590d95adf30acfee38a777de0f80d3efc7a07ea1fe68fd7eb03247a7"
  end

  def install
    # Vendored fmt 8.0.0 trips Apple Clang 21+ stricter consteval evaluation.
    # Issue ref: https://github.com/fmtlib/fmt/issues/4740
    inreplace "src/fmt/core.h", "#    define FMT_CONSTEVAL consteval", "#    define FMT_CONSTEVAL"

    system "cmake", "-S", "src", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DLINK_WITH_ABSL=ON",
                    "-DSET_ABSOLUTE_INSTALL_PATH=OFF",
                    "-DBSON_DEFAULT_IMPORTED_LIBRARY_TYPE=SHARED",
                    "-DMONGOC_DEFAULT_IMPORTED_LIBRARY_TYPE=SHARED",
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
    inreplace "fastnetmon.conf", %r{/tmp/(fastnetmon(?:_ipv6)?\.dat)}, testpath/"\\1"

    pid = spawn opt_sbin/"fastnetmon", "--configuration_file", testpath/"fastnetmon.conf", "--log_to_console"
    sleep 60
    sleep 40 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"fastnetmon.dat"
    assert_path_exists testpath/"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath/"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath/"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end