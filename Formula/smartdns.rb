class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoH/DoQ supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://ghproxy.com/https://github.com/mokeyish/smartdns-rs/archive/refs/tags/0.5.2.tar.gz"
  sha256 "f8f1cf190bbe3a03f7022558b6fcc1abd2447ccc5b64813ec21f9eaada4798ec"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "493ed441ace54ab542524fa052360876a578cb49d5aa77a841487ee745eee4bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8fef25531cddc5badaa34e13d973721e24a5a63283650fab6197a63c28599df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51ad30bc939e7caa062532ca7e44ab7699ac78e9ddad8568d00a7d88d54413c9"
    sha256 cellar: :any_skip_relocation, ventura:        "1ce7f2a603ed139bbeae99e4c9f7e252b2daa266b69cc91ce0df530caf5d2ea7"
    sha256 cellar: :any_skip_relocation, monterey:       "1f2f0523ee2d8a073f9ab923af8b62fcdd1cd0f88b6786411cee07049cef5d4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d04eb9e242bf3eefeab3f55fcdef1fc7a42a0d2461efb5c38efd8a94065e2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ddcf3fd47633efddf84f5d9ae19b8d1eac64d339b8bb3d15946c1dfa1b7ebfe"
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