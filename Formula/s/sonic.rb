class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghfast.top/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "578fb553a064f4343297462408e0841ccb00e3c90003ec1201c1ff27651d3d48"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2f073d0e2a67773d38113c298b8d1993eebfa2b0b3fcca536830191a2da047f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e12384125994ff6c832ea246d8229f7d07915f5de9c0beb752af77ec728f56f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ab22e8378010be388adcff073fb95394b30e29e37af1f870d13fa5d0e4777a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2831e350c6998ed702e55f4a4771cad1680dcecd7231e7cbc6fdda5f79fbd9cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9baf69f7a10e95efd51f63a6cba93bc6aa7674d526ed1c4bf52f585b14e0f941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd40fdf74bb19ea133b8e6d147c176da288a9aad460fe0eb2f20a5bdb885104"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin/"sonic", "-c", etc/"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var/"log/sonic.log"
    error_log_path var/"log/sonic.log"
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    pid = spawn bin/"sonic"
    sleep 10
    TCPSocket.open("localhost", port) do |sock|
      assert_match "CONNECTED", sock.gets
      sock.puts "START ingest SecretPassword"
      assert_match "STARTED ingest protocol(1)", sock.gets
      sock.puts 'PUSH messages user:0dcde3a6 conversation:71f3d63b "Hello world!"'
      assert_match "OK", sock.gets
      sock.puts "QUIT"
      assert_match "ENDED", sock.gets
    end
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end