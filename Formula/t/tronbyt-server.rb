class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "2abc87eefe2cce90b2527c846c879e87793c49ed4d4a19534d649a59af0667d1"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2238c21ff42b763143e540a66ece62db160b4daa15b2e1c991572dca1dd492c0"
    sha256 cellar: :any,                 arm64_sequoia: "fd962f9c0be23c05afa2a05a3bd3d63c0df76238f147368842422e99a49e429b"
    sha256 cellar: :any,                 arm64_sonoma:  "d4b71c421f8aa6f7da5c03377d97cadf394d7da4e5c9032bc3f951ec0252d3dd"
    sha256 cellar: :any,                 sonoma:        "5679633c28a7b65e73bda067ddf1e10f6c080d57a0f14a28baeb7de31d060f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37771fce8ab06950d24df81f9ee813a0092f22babb5ec79fa77ede0101bf3560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761da749f761ea6ba11c4b9aa8701990a60df4d49cb6445ac2cda3278e85106f"
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