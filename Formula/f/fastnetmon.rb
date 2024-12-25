class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9299b17e960a0a658eb30f446e0ab73844347c3cfbc47d23a83cfac265bad54"
    sha256 cellar: :any,                 arm64_sonoma:  "ce88a842e3dd91f51e77177329a98140cedfbc56eb29ee817fc607aef4c4d999"
    sha256 cellar: :any,                 arm64_ventura: "d0555ae5c9470e421f2f34dcd3e132758a18a3b36a2f6467be87c1fb1dbe8834"
    sha256 cellar: :any,                 sonoma:        "f099031849eaade4336780175c076e494393be12ffe340e62927c1be849a5024"
    sha256 cellar: :any,                 ventura:       "280c6e9153debe69a71513af6fc47a65a520a1af76842265a32493531fa23b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5d6eef3e64d59b152ae60f728174f2a87c5a6518cc17925c9756e53855a1676"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost@1.85" # Boost 1.87+ issue: https:github.compavel-odintsovfastnetmonissues1027
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
    inreplace "fastnetmon.conf", %r{tmp(fastnetmon(?:_ipv6)?\.dat)}, "#{testpath}\\1"

    pid = spawn opt_sbin"fastnetmon", "--configuration_file", testpath"fastnetmon.conf", "--log_to_console"
    sleep 60
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath"fastnetmon.dat"
    assert_path_exists testpath"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end