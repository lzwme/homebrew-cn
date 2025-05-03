class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https:github.compavel-odintsovfastnetmon"
  url "https:github.compavel-odintsovfastnetmonarchiverefstagsv1.2.8.tar.gz"
  sha256 "d16901b00963f395241c818d02ad2751f14e33fd32ed3cb3011641ab680e0d01"
  license "GPL-2.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1b311248b2ad6501f7bdebdc02d89c4547b48b16eaf71abbda723f09c06c1bb"
    sha256 cellar: :any,                 arm64_sonoma:  "7ac7cba2172d0064f38424222b9794d23dba51c7b789c36762335d293456da7c"
    sha256 cellar: :any,                 arm64_ventura: "c89c4a0c41f7d8ec4f3aa7ad8fcc7cc2b436521e47a9510f419836a44fc8909f"
    sha256 cellar: :any,                 sonoma:        "8f231656ced3a673ea880c669f5a743f40c989f6f0875719aeeb7e591440c2c8"
    sha256 cellar: :any,                 ventura:       "99237c9e8a8ef55b52acf861bb9b6655ec66d8eeb7cef1cfb410e4c197971ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8671cd5d9ace41d98ef6100d0819f92c1d72ba5d505aac2b228ec7cfc4c74920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3524ed8577261a76e9fb2c07b5b3dc752d8471151e33bc84e0994cfbafa07f57"
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

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
  end

  # Backport support for Boost 1.87.0
  patch do
    url "https:github.compavel-odintsovfastnetmoncommitf02063204d2b07a525d70e502571b31514653604.patch?full_index=1"
    sha256 "273d22bdfae85e464ab8cc1044423b2589800bef1db649f664049030f2cf719b"
  end

  # Backport fix to build with Clang
  patch do
    url "https:github.compavel-odintsovfastnetmoncommit8a91b5a8c8be1af0fe96ffe1ee1c002c30494662.patch?full_index=1"
    sha256 "cb2dd41177c73ed3ef4ee3a372d8f99b6471f695041dc1c05299ea03a572a202"
  end

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DLINK_WITH_ABSL=ON",
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
    sleep 40 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath"fastnetmon.dat"
    assert_path_exists testpath"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end