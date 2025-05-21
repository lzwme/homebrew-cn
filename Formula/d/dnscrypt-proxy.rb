class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https:dnscrypt.info"
  url "https:github.comDNSCryptdnscrypt-proxyarchiverefstags2.1.10.tar.gz"
  sha256 "f19d131956043232be993079d2ca4011c03386eefa72b8dc3e37d78f76b1a084"
  license "ISC"
  head "https:github.comDNSCryptdnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec8eaef77f638b2f5275d0e2d825a3c7f75e491c106a1b9f49db73b15cf074f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec8eaef77f638b2f5275d0e2d825a3c7f75e491c106a1b9f49db73b15cf074f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ec8eaef77f638b2f5275d0e2d825a3c7f75e491c106a1b9f49db73b15cf074f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b925fe85facf23c82fe753795716e77f188706b199edc7b1d36624aaba3a9661"
    sha256 cellar: :any_skip_relocation, ventura:       "b925fe85facf23c82fe753795716e77f188706b199edc7b1d36624aaba3a9661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dbe301eb88b5c80e9544ccd8ecf80aa7f080831adcaefe1d428662cfbc6b6a8"
  end

  depends_on "go" => :build

  def install
    cd "dnscrypt-proxy" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: sbin"dnscrypt-proxy")
      pkgshare.install Dir["example*"]
      etc.install pkgshare"example-dnscrypt-proxy.toml" => "dnscrypt-proxy.toml"
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
        #{etc}dnscrypt-proxy.toml

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

        sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

       resolver.dnscrypt.info
    EOS
  end

  service do
    run [opt_sbin"dnscrypt-proxy", "-config", etc"dnscrypt-proxy.toml"]
    keep_alive true
    require_root true
    process_type :background
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}dnscrypt-proxy --version")

    config = "-config #{etc}dnscrypt-proxy.toml"
    output = shell_output("#{sbin}dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end