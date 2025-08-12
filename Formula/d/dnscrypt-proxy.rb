class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://ghfast.top/https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.13.tar.gz"
  sha256 "7f6a3d2613f91ace402f2f682929529565a54d6d7e4213403e7e6a0db448bddc"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2a9fefe84ef2ffc829031e377fd1b7312487aae8eb0ede34b251f29fab93a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d2a9fefe84ef2ffc829031e377fd1b7312487aae8eb0ede34b251f29fab93a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d2a9fefe84ef2ffc829031e377fd1b7312487aae8eb0ede34b251f29fab93a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab1431ae96a6ca889b19c34a297693050345aee97dadca212cbc2446839f4b4"
    sha256 cellar: :any_skip_relocation, ventura:       "2ab1431ae96a6ca889b19c34a297693050345aee97dadca212cbc2446839f4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "609e5a73e61ad5a6780dbb45a99104dffb5f537078423866f63fd9a29c40064a"
  end

  depends_on "go" => :build

  def install
    cd "dnscrypt-proxy" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: sbin/"dnscrypt-proxy")
      pkgshare.install Dir["example*"]
      etc.install pkgshare/"example-dnscrypt-proxy.toml" => "dnscrypt-proxy.toml"
    end
  end

  def caveats
    <<~EOS
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      balancing traffic across a set of resolvers. If you would like to
      change these settings, you will have to edit the configuration file:
        #{etc}/dnscrypt-proxy.toml

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

        sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

       resolver.dnscrypt.info
    EOS
  end

  service do
    run [opt_sbin/"dnscrypt-proxy", "-config", etc/"dnscrypt-proxy.toml"]
    keep_alive true
    require_root true
    process_type :background
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy --version")

    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end