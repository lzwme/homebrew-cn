class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://ghproxy.com/https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.5.3.tar.gz"
  sha256 "1eecf1189e008b3144bdd25cd478700105e25b9838efa78ec85b42ac01f54d80"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29feb562a262f3b28037c99e8acbc2c3197e2ead20d29c4bba4c11dfb35d5531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7bd10cf2738b95ff1437a2f4f145d6011fedb2954f84fff2b69562d654a96e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb4dacc47a96967f5a0f7f8b4a4e5fc96af0bb76a08cd233f14552b1def560b"
    sha256 cellar: :any_skip_relocation, ventura:        "f7eabdad14ca39504d88c76b568bedcf065af4ebcb521509e66eff093b0acb9d"
    sha256 cellar: :any_skip_relocation, monterey:       "51535488d5a2803e4783f2bec830b4e321bcc61c2b44fbfc96711e6f5653ae02"
    sha256 cellar: :any_skip_relocation, big_sur:        "28317a3a07978b7d9bf3b7cf9a695b1885a20cce89df736e36325c075261f8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76f38c5eaece483b48aa581f7b3a8509a7b674fb258a629be82f87041f797d9"
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