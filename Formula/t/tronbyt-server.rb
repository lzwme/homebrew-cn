class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "8e0ca61907cbdb83caaecbf9f630927ad572cb574bbea683d3f0f17ce9f4a9ec"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eae6c3958be7ef15eb93c255fc53d53bd5fe1c150b7a0ba546041a5ccb501f7d"
    sha256 cellar: :any,                 arm64_sequoia: "1fcb54d919abb18e945c667855c93a16f8c950a4c1e76a043461ac20d9b92380"
    sha256 cellar: :any,                 arm64_sonoma:  "ed0bba9ef136937109205f71637aa0f541cdd3bd3443ba0c2e2ce9b3e6a87185"
    sha256 cellar: :any,                 sonoma:        "d97dd035985cd7d6ba15451fde4af2b4003023a51bb0211963c7244a35f22ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b549c4dfea44ac1b18cbfa7b172f09a9dae17d8f37c8bc291751ca7a17feaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974a73ea2d83b721f21f3ce4b7372e45c4dbe736543562bab652d4803059b23d"
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