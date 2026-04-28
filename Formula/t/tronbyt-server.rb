class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "7689ef25d486b417dcaa84aac22781b8dbccf383f4b1dece194d7bd843fa97a6"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2486852d4b8a6fd11db61999bc25f22b2b2e31fb443e4a2f73462e17aab8f922"
    sha256 cellar: :any,                 arm64_sequoia: "9baec336c3e704bcb2139cbe0456ed9d90807d8666a118675107a13ccbf12c67"
    sha256 cellar: :any,                 arm64_sonoma:  "a8e5f5e0b51942ccc80352124c892d0fc30a67f4009f9f168bdf98220d72bf1d"
    sha256 cellar: :any,                 sonoma:        "db73285e0381fbeb8a22f6ad1f4c082bac81a7da1620fcf55f9c6fa834538624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1461164c305a2e38acebe687061796705e2ccdabd40bbfd874ad4fcc6727476a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9929648d0e0ba8147663aa5936a2560544702faaab8be3d81da1e2512a3d01"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    ldflags << "-X tronbyt-server/internal/version.Commit=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  def post_install
    (var/"tronbyt-server").mkpath
    dot_env = var/"tronbyt-server/.env"
    dot_env.write <<~EOS unless dot_env.exist?
      # Add application configuration here.
      # For example:
      # LOG_LEVEL=INFO
    EOS
  end

  def caveats
    <<~EOS
      Application configuration should be placed in:
        #{var}/tronbyt-server/.env
    EOS
  end

  service do
    run opt_bin/"tronbyt-server"
    keep_alive true
    log_path var/"log/tronbyt-server.log"
    error_log_path var/"log/tronbyt-server.log"
    working_dir var/"tronbyt-server"
  end

  test do
    port = free_port
    log_file = testpath/"tronbyt_server.log"
    (testpath/"data").mkpath
    File.open(log_file, "w") do |file|
      pid = spawn(
        {
          "PRODUCTION"   => "0",
          "TRONBYT_PORT" => port.to_s,
        },
        bin/"tronbyt-server",
        out: file,
        err: file,
      )
      sleep 5
      30.times do
        sleep 1
        break if log_file.read.include?("Listening on TCP")
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end