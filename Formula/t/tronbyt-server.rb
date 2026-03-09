class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "7f99394d43439a5f1286bebd89bd5e0b65f470d600ac08075df5352c9d30cd06"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebc52e33bd01d699966311ec025e88a52404fc5d7121c62032d134a8e25f6504"
    sha256 cellar: :any,                 arm64_sequoia: "e4160bd1621613f889af6b5a947e203411d341c800d9221095a4c9beeeb1d9f2"
    sha256 cellar: :any,                 arm64_sonoma:  "b62430362afd2ef9619d99022b3202b223148c392b274035db32c21895fcad28"
    sha256 cellar: :any,                 sonoma:        "6ee27c549f35506e859ba86fcd207eb786b63b60a77fcbfa0d5e8fec6e3675bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4fd4a3ccb7bfb678520e4142475b74d8f453a0f9eeed204e67a0d045f3db32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141e736087c3ce9804d204d53026dd99553d115b1088871df35bd3fae35daf7c"
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