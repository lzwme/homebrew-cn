class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://ghfast.top/https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v7.0.0.tar.gz"
  sha256 "3580962861589c0b69efd6b385ff92ad8fdf688c91d1a0edc1a83278205e28e8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "835f85d5c189736a2d11dbbac0dafdc6e828bd8c989a599ece624f39878c8f97"
    sha256 cellar: :any, arm64_sequoia: "02a68549b1d65f6fb5ce8d972c1c23f7a87701e2409a9c4f5d7a8b99ac7c4827"
    sha256 cellar: :any, arm64_sonoma:  "ce450553ad34774e92bd2405f4619671767bc9c405c861a1eb4b3746f571b15a"
    sha256 cellar: :any, sonoma:        "258df9fecaf867741cbc0571695b774d4e2f44b4be5608451f5667993f9531b1"
    sha256 cellar: :any, arm64_linux:   "547ceb9038ff36fdbebb311b754884f56db721ad7dfa9b2655cb0581d9752925"
    sha256 cellar: :any, x86_64_linux:  "a7941a75d022528ca41246341b2ec0604bfecdc681b1463025d84f643108af77"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "libsodium"
  depends_on "openssl@4"
  depends_on "protobuf"

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DDISABLE_VCPKG=ON
      -DDISABLE_SENTRY=ON
      -DDISABLE_TELEMETRY=ON
      -DBUILD_TESTING=OFF
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    etc.install "etc/et.cfg"
  end

  service do
    run [opt_bin/"etserver", "--cfgfile", etc/"et.cfg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"log/et/etserver.err"
    log_path var/"log/et/etserver.log"
    require_root true
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"etserver", "--port", port.to_s, "--logtostdout"
    end

    begin
      require "socket"
      Timeout.timeout(60) do
        loop do
          TCPSocket.open("127.0.0.1", port).close
          break
        rescue Errno::ECONNREFUSED
          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end