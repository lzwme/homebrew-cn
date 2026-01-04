class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "612abc92eed71f790ded5567089473cb34d8ed8b285550afd7389aa7b98b2838"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6b08850e20751b6c2a179b874492e5b4c85b599ee47ab85bef7ca58f01db74a"
    sha256 cellar: :any,                 arm64_sequoia: "71e7688e2192d78046012c966c711c2fb36552b617ca525ad69b49f75f3cb396"
    sha256 cellar: :any,                 arm64_sonoma:  "45d380e109d65f374e79450ab429cc91cc2019686125220c2c503f2c9283cfb0"
    sha256 cellar: :any,                 sonoma:        "305b5851762410a661385c656d912f6241acaeb31c8885ae3e338f121d784b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f86e5fbddac71e3900da02034d1d27d6ca4755d7ce39b1421c7d887c6269b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76fa2be3f96c471ab1a60f2f5feecb0c5fb5c8cd27897b503152651422e7538"
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