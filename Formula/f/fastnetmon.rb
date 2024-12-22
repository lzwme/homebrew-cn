class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56970d538952e97b29ea0fda16f5789e796163cd3c91d09ece5b10a4c90a36ed"
    sha256 cellar: :any,                 arm64_sonoma:  "b1374ae567e282b0e31c670953c95dd5b3da7ab04fc13ac82233dffb4ecef5e5"
    sha256 cellar: :any,                 arm64_ventura: "15e20ef0b23977def4e3e136fdb5d083c36f81b0b190d5a74f3e5e60e4687caa"
    sha256 cellar: :any,                 sonoma:        "cba9893154bd4e67a30a3a355f1605fd0ddbccf930722a7c805617e05616d827"
    sha256 cellar: :any,                 ventura:       "38c45f7dffae3cd7a25db6c1d2d796be4c7c26d3843a19cdcf802efdf89b67d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e154e9e9c271969d23033457280ffd61b80e2debeb044853d5683638654b185d"
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