class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "88fde139818ce145022fc4d7d2744116279165489feff2490089b44dbb3e6d3a"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "382e418d72f514b3ac782a7357e41c329ec159a70097b825280d13113acb0e6d"
    sha256 cellar: :any,                 arm64_sequoia: "54510634274545aa5b304ac2535dcf806cbea061b0399a603d80e515b33a4122"
    sha256 cellar: :any,                 arm64_sonoma:  "2ec3ff171b490dd81d87568d7f61f1464472dc4f29234277c930371be7e0fbb2"
    sha256 cellar: :any,                 sonoma:        "1cd74a082f01946cc68f2a4b8f06daf49115620af445eaff6451bf1611a3bbf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6f18df7b2ed6216349ef0d81aad88e977e97bb139652eca5b2d6080393288b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f3235b298e25c8baf9c608461b8f71d01e2a1dbb7967c152e8cc584c79d3fe"
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