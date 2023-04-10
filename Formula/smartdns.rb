class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://ghproxy.com/https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.5.4.tar.gz"
  sha256 "651165cdd2ccae4a20ec20e72130729e667c953c7fb40366b906fd78efd34b76"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86722ded76a4c5baa57b281e511ac4e6bdff1925500b706f53012a6f66408520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d48b7636968229aab8789cd006dfcf094252653ec44e68d2fd48e3aad2b52fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a7a119c22f04ad78612ba594c28497caa124152e07f59b2611ca89f9fa28d14"
    sha256 cellar: :any_skip_relocation, ventura:        "710ff2c131b1f48c1100d85f97e044af1d94252b2edd21d4305e530bf795c0e4"
    sha256 cellar: :any_skip_relocation, monterey:       "9118c825ac9c1a57afa26f555383f28ec7833aa759e6b74b7568cb6d258950c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ce40275d3f2ede819177c8a7d868b1128d0993bb3a2956d16fe092ddc913458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c497c9eef57c0dfc9fa0966c38061db86b32f0826d6bcff42f88f2dc5c0eb52"
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