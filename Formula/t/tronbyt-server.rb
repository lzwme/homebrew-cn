class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "ccfbdaca976bb277a85f9cf35d9ae0c765e78f92fbd209f331afa57e67a96a8f"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "055d41b045f12fa0011052052a7ac0b384beb5fc649e89bef24346e0a0084584"
    sha256 cellar: :any,                 arm64_sequoia: "fe8bb6c5579f5e37bbaa777084f70edcce14fa180ceff525c2a6b54bffb18486"
    sha256 cellar: :any,                 arm64_sonoma:  "af414328d62b2fbebd0de001d41b8807dde3c66f9bfbedd8b951748ecf29cddb"
    sha256 cellar: :any,                 sonoma:        "0185030d3caaff8715fff04601a9a36b97addda883a124ad864275eee5fd4468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc6bcde30c2ba10827da50591b10295726229fe90aaeb7b46ae0a9cc22488160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20405abca115895ed0af36c4f7c1aafa203bc5c249b226375681f5ff695f7051"
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