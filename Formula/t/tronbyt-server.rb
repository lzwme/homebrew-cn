class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "35b2bc2973259541ffba6f87f87f6ace5da5e57d4f61be206e43ca538ee62526"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6e912add0143302b56dc0001f31518f14329a47f4382ad7c86bebc33b21033e"
    sha256 cellar: :any,                 arm64_sequoia: "995f0264ddd79fa23b684318a4a43cfd1f5e3f85e857dd0c8063123e274efba1"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e38e62ed73fded89bc9b7a62dcbebfa85f0b72da0d228d41a582e1f49257aa"
    sha256 cellar: :any,                 sonoma:        "181609bea399fe283971aa93daa99036dc478ff18d256c6c7b04c5a94052b00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a8aa6c476c7092227dcd5bc15f02895855b78c376146c6c0b80ace10a340859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb246859833ec66f0adb599e34fdd7c9b150011cfce9b6ad5530803d961db063"
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