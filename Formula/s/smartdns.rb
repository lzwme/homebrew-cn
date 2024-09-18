class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoTDoQDoHDoH3 supported"
  homepage "https:github.commokeyishsmartdns-rs"
  url "https:github.commokeyishsmartdns-rsarchiverefstagsv0.8.7.tar.gz"
  sha256 "ac40d99ae81b56d1a6823c2032e00ccece531160cdd8a1c4918625d11875ad26"
  license "GPL-3.0-only"
  head "https:github.commokeyishsmartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4345d2aeda6e22f7094c19dd7e70991ab2780ecf29a25beb0c7872379f4d6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3bdc930ce66ab7ccf651edebbbc96bee5d5b2388b6726e7e7a45a985a65b03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23138d4afecb99e116ff825ed003ebe6aadd3af2db6350aedcbae024226722be"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f87fdd551ca26287b878acef6442d790cc12993d7179784fad912034d3f2224"
    sha256 cellar: :any_skip_relocation, ventura:       "b0a5ce653f6f4014ab975fa8331b5ec7d0b33eeefce788d2ca493cd70d87b8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc81a10b94e0c9d949ea16e6432127092f6e8c5aa84b986620ee8a0af2f0181c"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

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