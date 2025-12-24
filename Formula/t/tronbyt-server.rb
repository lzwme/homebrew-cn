class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "6eb253f06b67edac94b901a39ea2fcb901a49752a4fcb8b1bd744ff364614b73"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "567b70da1a424ef840f7da7784dc1985201e45fca31711de7b1c4a0b230727c2"
    sha256 cellar: :any,                 arm64_sequoia: "5f5d19daf5953feeef52abb0044907fbc1d231866ce97944d91c1747c487f4a9"
    sha256 cellar: :any,                 arm64_sonoma:  "a8139eb7df06e5eb9538bfe97c2fb50b3a64a77ae6fb049af3c1e0a43c0636e8"
    sha256 cellar: :any,                 sonoma:        "ad590abbbd95aa18328aef217fa9e4985ac87cceed66355081ba9179ee2bfa78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f136a8ea9b1e9ab5e2d536176a2f1701cb3f5eb0289fa718acfeacc84534edf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580e5ed8becd1bd83e7e03cc535fed8dcbbad30f8b8791a2c98b090ff4396cc4"
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