class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoTDoQDoHDoH3 supported"
  homepage "https:github.commokeyishsmartdns-rs"
  url "https:github.commokeyishsmartdns-rsarchiverefstagsv0.8.2.tar.gz"
  sha256 "7bd628e39cc9c055eb885a84c7b329cb3651f04bea524566fb15420a8c548f96"
  license "GPL-3.0-only"
  head "https:github.commokeyishsmartdns-rs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7f9ddee167944fcb9b0325746a8c64b70a8d54a30819fc8900f871ec3ba1d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc9240804615c4d0626142e31480c0279a6ce128c8796d30d58778ea53c23c42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57fd7afad91850022f39ca0616ac155c165e651f5385a271fd7dba1f7bb3123"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2b84775bb3b7e9639805d14565a6811c36bff07d1c1fe2672ee7e6dba57b28b"
    sha256 cellar: :any_skip_relocation, ventura:        "9b25a21458f6a09b36c373c5b59dee8d09d7428f4f10fa948f1e6fe2336df20c"
    sha256 cellar: :any_skip_relocation, monterey:       "e37bf3df3daec20dfe562a8f007582f1e7872b7bfee07b646922e96cc5577df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0003fc138a1c55a9c32e33ee89a2d825d486a71008821972b6bc58346d3fa1"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" =>  :build # cargo patch
    depends_on "pkg-config" => :build # cargo patch
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "just", "install", "--no-default-features", "--features", "homebrew", *std_cargo_args
    sbin.install bin"smartdns"
    pkgetc.install "etcsmartdnssmartdns.conf"
  end

  service do
    run [opt_sbin"smartdns", "run", "-c", etc"smartdnssmartdns.conf"]
    keep_alive true
    require_root true
  end

  test do
    port = free_port

    (testpath"smartdns.conf").write <<~EOS
      bind 127.0.0.1:#{port}
      server 8.8.8.8
      local-ttl 3
      address example.com1.2.3.4
    EOS
    fork do
      exec sbin"smartdns", "run", "-c", testpath"smartdns.conf"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end