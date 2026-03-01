class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "eadadca3ecced750c70c2ef5928350bfcff34dda570dbb1fb203710016bce99c"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7077e334bbaccc44ac33b7fb17837e3236f511270cbf65528dbdd88162a0466"
    sha256 cellar: :any,                 arm64_sequoia: "9e495e9f18335fbdd3452467abf8b91e33fcbe2c7530aa9c482cd0348146a4ef"
    sha256 cellar: :any,                 arm64_sonoma:  "7d500c397811e3901ae8bdee5ee7332d3255f4a5eb93b38f7a1a9a11d91f90b1"
    sha256 cellar: :any,                 sonoma:        "9ca86e767404f476ad826c5d76d394797ab2250531b207debe0234723ac92ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfd84cadc0d8912eaa5f001559cd23a2314861d1e0b6dd098bdfc29c2fb166be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3b6ad46cde36a0cb0a83c31e396f8e3fd69acd66f883811745b35c9205aac9"
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