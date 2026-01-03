class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "11a3bcb8826dec8e264fcdc97a78484c87d2925bc000a11492e547db74f92508"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fba584dc2f9848edd48fa200c7960e14b4db64b8cd4e73f340b8f51dee678e10"
    sha256 cellar: :any,                 arm64_sequoia: "5fd23f4717774d7c0606f608b6e69e2a11c663c18c7401829212b8881b73053c"
    sha256 cellar: :any,                 arm64_sonoma:  "d23133c6b6ecf5028c5c2159e03194de1c4ac1a0e64e66a92b1cef5f5f07bb7a"
    sha256 cellar: :any,                 sonoma:        "af5332d7ebfe0cbbccbe0cd0698a0d998a6c17617b3390c80d0b119c9aeec4b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbfd32ba02882b72b79446369a042d95d3b39bd5b6a84860650d637c29f083a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1abbea35c1265d4e198001651bc33fd1b6f9e88a317120a0812b603cc2dad097"
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