class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://ghproxy.com/https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.5.1.tar.gz"
  sha256 "4043abf132579781e9004691ef528db3cd8297f9c75ff5f3759a507ef118174c"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eeef710c9574f88b30b4097c1882ee77f4bb80ca749a59960d48925e7e70d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c09fa10349c2dfd14af4a3f2534c1140c024f321ba629eee8bf46ab31ad551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "574bec2971e4b9ea95f1149398655e8eee7af85fe7fb04bf8d0f082416dcddf7"
    sha256 cellar: :any_skip_relocation, ventura:        "fd609ec68d9c8ca8dafe333d5cf8807fb1fef75ee12305f870b78b3f1b95d0de"
    sha256 cellar: :any_skip_relocation, monterey:       "185614110459aad3d12f60e707a0ce33d2d5063f22c4452141688c877b49890b"
    sha256 cellar: :any_skip_relocation, big_sur:        "36e1437485e2ec2a9ebf35e65e45ac5eeb4c6421d3a3cca5f1fe1535c08f0fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df98bd0eb3821b794e5c0da0545d51e410fa493cc5f131db90a9b8598af91d93"
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