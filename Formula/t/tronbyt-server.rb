class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "4fdee83c49ea4df7a69209d6cd7e688a7a4a459669edaddb5f77da50b409c931"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf7980be0084f305efacb1c99ed4735455e8f0e73015e7640602737abab9af73"
    sha256 cellar: :any,                 arm64_sequoia: "d101ec120ac83812195f60fb5383073204578724df541c06e00973d8cb935fcb"
    sha256 cellar: :any,                 arm64_sonoma:  "43dd1cb3b7a6fccb68f36a82f9d35696945fb309c175d1075291f347e655675e"
    sha256 cellar: :any,                 sonoma:        "82206cfe91dee348e95bee9bd1af159dd4ab9f11d58745ab9afb820ed01682a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f15cd28861afafb8fa629585ac250310435bcb0b23a181435cf8bd6bd425e481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb6588b912a90716860552337fd1d54d2d000f970bab2c792210054a572f79b"
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