class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghfast.top/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "398c3d9b30001bf779e01061c082a81ff9a4d74774e4e647f9d5174d3180e8d9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f5cfd8c856de99311a25c374516c986dc06c65f1c22a6a8b5dd1cc2586525a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc84c523da6e20c0e1e3e8c7a3f21efccfbe398269e097c930b989223bcfcb80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7580eccbb68b15a90ddd44da37954fb92699ff1071485429eb1c3e63922130"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67bc7b1b33ba82d193b7b3a154e837db6053e2a97b420e637dc8909974405f8"
    sha256 cellar: :any,                 arm64_linux:   "e2f143a2283505bc33f8cea18328ad00c11e87f13c98717c35cb2c713ceb2cf9"
    sha256 cellar: :any,                 x86_64_linux:  "d35f46a0cc57c05060dfcaa0ff0f65d696407f292572508bfbdc8fe1bc384dd5"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "server")
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