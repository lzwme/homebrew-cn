class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39fe6a0f55bff703d2eb2841c6dd245f5cf40b3e27a6cc20e5a7ffb4bcc745ed"
    sha256 cellar: :any,                 arm64_sonoma:  "020434745e3c21a4d337dc14d940fa752cb8c7accb76f4e8101a06300267c79f"
    sha256 cellar: :any,                 arm64_ventura: "32b144404b8e34c6eb62d4ad2acaed1850c25619a570087ba40928be97bb6157"
    sha256 cellar: :any,                 sonoma:        "938c8411be67fe522ed70488a7f3d707ed4d87852ec9a8c7ea6943c16acf958f"
    sha256 cellar: :any,                 ventura:       "acf5ca43511990cbc36e356de87a257440305cd52f4f9b7796e674bde04ec2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518f30fc31af9efef2a8c8768f187100f1e1d062ff20c32cd7d9e537b0b30f72"
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