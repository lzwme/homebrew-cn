class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghfast.top/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "9f97975db0e9c53cd96bb37c1d24ac9e8dc16f09a25d4042fc73ea3285391967"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0acd2a6bcb7affecbee70ec2f46eb05608365b11243818cbac0a5873dd1f33a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fadf044670f36c7eb8da3f9c323e4271baec0ea7557d4e97e70d3fc86c305e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "883a5d60861a698f9f00068ea3c5be29cb7fe4debaf7dbe9366b2b8caef0ed1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a99068609128750788179b83bce402d43545dcb7b4287e0da1f8986e004683"
    sha256 cellar: :any,                 arm64_linux:   "39385e25ef644c4913223bfce373dffdc00e660584c8946f1cb94db2100ae323"
    sha256 cellar: :any,                 x86_64_linux:  "340dfb9318462ffcc15d498a1887d65594571570a6c00536e9ceec01afca0dfc"
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