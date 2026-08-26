class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://ghfast.top/https://github.com/tronbyt/server/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "e5b7c05c882613428010428c4e4455f7af229f510aa8efbc7817d760b68abdf0"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a45857e6ca67511e468d15c05d1e6cd0d2fe08eb38521ea577d1dfe5163458d9"
    sha256 cellar: :any, arm64_sequoia: "e24519852f692b7872931ebb8d9102bd4f46f2cf64c6defd9e370c89eb284e30"
    sha256 cellar: :any, arm64_sonoma:  "86cb52dccbed50940b490df39841e7af564c64b12d84212c87d0174950e50542"
    sha256 cellar: :any, sonoma:        "0e6d8fa74cc27105812b55a7d8f7a7a5543e13ddb62a3078c8d2f8fbb5449879"
    sha256 cellar: :any, arm64_linux:   "4583460e7ade36468d6df06230cc0f5c2ba5b2019276e00651cc1c2dde80c0c2"
    sha256 cellar: :any, x86_64_linux:  "be2b23f71533893c7f9d06cef4fa89378a280ac8fc30bcac7359a40f4c421cb9"
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