class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://ghproxy.com/https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.6.3.tar.gz"
  sha256 "854db02059924279662b61256de72d4fed1bcfd7ef95a15e52d28606daa20585"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5961585823457a93bf1de6731bb5042a23a659eb5fb960a6db065dd62d3ac32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd3d8573fa8415917cfde305886db98134cb8a224c3b78d947f574f3fd2b1995"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d939ecf2e47ad5088b1cc9074b5a6227bcb91daaa7f921bccc7476085fe5cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ab4f96106721f97242378397edabed468b4a4e644c902bc65c37a96c12068e"
    sha256 cellar: :any_skip_relocation, monterey:       "f803b616d387ec6fdffc849afacfd1881c7fd8b59543718a67a9c538af899ca0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f55f79f060c743c4c0b6ec016120d75fc2d00e3e0f6aa13408efd6c202cf3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9355dc9e7141393ed01ac30b7ad5241ed86d56c4d2911ff3a7cab5422d417520"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", "--features", "homebrew", *std_cargo_args
    sbin.install bin/"smartdns"
    pkgetc.install "etc/smartdns/smartdns.conf"
  end

  service do
    run [opt_sbin/"smartdns", "run", "-c", etc/"smartdns/smartdns.conf"]
    keep_alive true
    require_root true
  end

  test do
    port = free_port

    (testpath/"smartdns.conf").write <<~EOS
      bind 127.0.0.1:#{port}
      server 8.8.8.8
      local-ttl 3
      address /example.com/1.2.3.4
    EOS
    fork do
      exec sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end