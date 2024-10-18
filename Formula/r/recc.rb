class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.2.25/buildbox-1.2.25.tar.gz"
  sha256 "c501f4666e8edd91f899cdc0470aaf28c711556c953e21d4dd7fbac900901006"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "1332b5699e9bb62f14e80af6879558c0e0e3ff7259f8f089d05b1cbb0e5ed2d1"
    sha256 arm64_sonoma:  "ed07e23502220de4f926c51839cd4e53f16bbc9c5c70406c6ab5dd1c7ceba268"
    sha256 arm64_ventura: "095b5a5568dfec35af8b96a42e8dde8e4f1824fa799badb47a137d2e9ea4ca72"
    sha256 sonoma:        "a97c14ef1074a3cd491e9874b3b8233b5f39df9586b6854fcd079ea09dd77020"
    sha256 ventura:       "35eea5eadfde77a86f5dd37701028396a8d4fd54e0e24b5630886022e2479a90"
    sha256 x86_64_linux:  "5776dc911c3133f978e5511e57318e97e16ff9b3a1e8e7aa439ee2b456644fa3"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "glog"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gflags"
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

  def install
    buildbox_cmake_args = %W[
      -DCASD=ON
      -DCASD_BUILD_BENCHMARK=OFF
      -DCASDOWNLOAD=OFF
      -DCASUPLOAD=OFF
      -DFUSE=OFF
      -DLOGSTREAMRECEIVER=OFF
      -DLOGSTREAMTAIL=OFF
      -DOUTPUTSTREAMER=OFF
      -DRECC=ON
      -DREXPLORER=OFF
      -DRUMBA=OFF
      -DRUN_BUBBLEWRAP=OFF
      -DRUN_HOSTTOOLS=ON
      -DRUN_OCI=OFF
      -DRUN_USERCHROOT=OFF
      -DTREXE=OFF
      -DWORKER=OFF
      -DRECC_CONFIG_PREFIX_DIR=#{etc}
    ]
    system "cmake", "-S", ".", "-B", "build", *buildbox_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "make", "-f", "scripts/wrapper-templates/Makefile", "RECC_BIN=#{bin}/recc", "recc-c++"
    system "make", "-f", "scripts/wrapper-templates/Makefile", "RECC_BIN=#{bin}/recc", "recc-cc"
    system "make", "-f", "scripts/wrapper-templates/Makefile", "RECC_BIN=#{bin}/recc", "recc-clang"
    system "make", "-f", "scripts/wrapper-templates/Makefile", "RECC_BIN=#{bin}/recc", "recc-clang++"
    system "make", "-f", "scripts/wrapper-templates/Makefile", "RECC_BIN=#{bin}/recc", "recc-g++"
    system "make", "-f", "scripts/wrapper-templates/Makefile", "RECC_BIN=#{bin}/recc", "recc-gcc"
    bin.install "recc-c++"
    bin.install "recc-cc"

    recc_conf_args = %W[
      RECC_CONFIG_PREFIX=#{etc}
      RECC_SERVER=unix://#{var}/recc/casd/casd.sock
      RECC_INSTANCE=recc-server
      RECC_REMOTE_PLATFORM_ISA=#{Hardware::CPU.arch}
      RECC_REMOTE_PLATFORM_OS=#{OS.kernel_name.downcase}
      RECC_REMOTE_PLATFORM_OS_VERSION=#{OS.kernel_version}
    ]
    system "make", "-f", "scripts/wrapper-templates/Makefile", *recc_conf_args, "recc.conf"
    etc.install "recc.conf"

    bin.install "scripts/wrapper-templates/casd-helper" => "recc-server"
  end

  service do
    run [opt_bin/"recc-server", "--local-server-instance", "recc-server", "#{var}/recc/casd"]
    keep_alive true
    working_dir var/"recc"
    log_path var/"log/recc-server.log"
    error_log_path var/"log/recc-server-error.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      To launch a compiler with recc, set the following variables:
        CC=#{opt_bin}/recc-cc
        CXX=#{opt_bin}/recc-c++
    EOS
  end

  test do
    # Start recc server
    recc_cache_dir = testpath/"recc_cache"
    recc_cache_dir.mkdir
    recc_casd_pid = spawn bin/"recc-server", "--local-server-instance", "recc-server", recc_cache_dir

    # Create a source file to test caching
    test_file = testpath/"test.c"
    test_file.write <<~EOS
      int main() {}
    EOS

    # Wait for the server to start
    sleep 2 unless (recc_cache_dir/"casd.sock").exist?

    # Override default values of server and log_level
    ENV["RECC_SERVER"] = "unix://#{recc_cache_dir}/casd.sock"
    ENV["RECC_LOG_LEVEL"] = "info"
    recc_test=[bin/"recc-cc", "-c", test_file]

    # Compile the test file twice. The second run should get a cache hit
    system(*recc_test)
    output = shell_output("#{recc_test.join(" ")} 2>&1")
    assert_match "Action Cache hit", output

    # Stop the server
    Process.kill("TERM", recc_casd_pid)
  end
end