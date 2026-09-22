class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghfast.top/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "1f9a332c7a8a87cef3eb0c6c2ea721d50e846fd5cab828623aeaaac82895da81"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "982bc8786502a98bce02f58580118fbc1e3cc7b9d30d3e28ec1a2ee1f480d09e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a8fbcabc0d75852f1352882e4e52e08ac4f7a24c29489c2fdca70ea2988f780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb48ed9a6298d90828f6823b9e65a6cf4c147a807450c8c81e02a7a8fb2df147"
    sha256 cellar: :any,                 arm64_linux:       "d51d28c2f08b5fd7f4979653388935f43fdb0b9ac905198e61d8e07dda8bc090"
    sha256 cellar: :any,                 x86_64_linux:      "9ac0f06f411b24b8d702337c6b5cf33957eca7fe5a23218ad2226978361bee16"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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