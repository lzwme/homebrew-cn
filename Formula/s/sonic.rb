class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghfast.top/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "6ab7c9f9be75f286c7dcb09d796fbd1159406bc607c3afb810e466edf130c935"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec32535b0f2d7775460c3f9a2e2bbf8a613b274f35c36739b4a5c54d78466ab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae82549620618d3ddd15e16dcc7e9ccdecaa9562a4b69abcde0b9ba25d80d24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd0125516a3dab6c121b795584c68fb3fdc003a457e190e9bce4529cf5d1d63e"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a4986e15ed2ca4a43e133c563774512d9db7744d6228e2f7117bdaf1fa7f0c"
    sha256 cellar: :any,                 arm64_linux:   "47cd79fa5d9bcfc6c2d4707e1211d011f362c54354cf316bb25b8b31af0763a6"
    sha256 cellar: :any,                 x86_64_linux:  "d1a9f4b72006684cbcce60d218f58185284d872f136dfa5b2e70bdf3661cf186"
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