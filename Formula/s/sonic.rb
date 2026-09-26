class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghfast.top/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "2139c199ae3381a47b2b59b0fcb1b201683b933dde321b40dddbec4ac0ece035"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3c9198a13f8c39321e28e77b83deab571f6e514519e35d4792cf61048dd869a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e389e47f8127ac3c9b7ed328ab7cc002ab5654181a37b8344e8627cd9001fab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a31b17f416f6301f39207e5a437a425e34fff1b7c2a88446b098d71b3c5ae3a"
    sha256 cellar: :any,                 arm64_linux:       "cae98c72d76d5bcb694386d5ec08be44b81a23f37c4aca186876fe1b85d5e496"
    sha256 cellar: :any,                 x86_64_linux:      "be70d210ded8b1ccb75d4755da201c278d79dedf82bd1d22a490fd5978e96f3b"
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