class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "3f40e355844996551506944c159a34f7c8dd2950cbadf5a15960f30d51bf73ec"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6166e76d518177145b53f8a5dd4dab2f2c6e05411f94f9f6fb30e79b0a319bdc"
    sha256 cellar: :any, arm64_sequoia: "5533884a3c9605d2978247aa96d77c03990fb745d5fc566d208b987b73b5515e"
    sha256 cellar: :any, arm64_sonoma:  "dfedb375a586aa1ce7dc15c0911d9f7bfd24df74dbead33439251c196de84201"
    sha256 cellar: :any, sonoma:        "ab324da53f4f135e4762ff22dbaf2282af664406764219f5a94190a33d100625"
    sha256 cellar: :any, arm64_linux:   "cece96963258caaa7eb03d2f889ae3585b3caba50d39a52b9457b027258e4f1e"
    sha256 cellar: :any, x86_64_linux:  "12b25b41bcac2bbb7350d43b31f6c9f27fe29bbca2f24150737b186a239a5498"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    ldflags << "-X tronbyt-server/internal/version.Commit=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  post_install_steps do
    mkdir_p "tronbyt-server", base: :var
    unless_path_exists "tronbyt-server/.env", base: :var do
      write_file "tronbyt-server/.env", <<~EOS, base: :var
        # Add application configuration here.
        # For example:
        # LOG_LEVEL=INFO
      EOS
    end
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