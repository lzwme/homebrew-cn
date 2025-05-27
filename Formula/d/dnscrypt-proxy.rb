class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https:dnscrypt.info"
  url "https:github.comDNSCryptdnscrypt-proxyarchiverefstags2.1.12.tar.gz"
  sha256 "95fe29ed03dad0cdd34d47316ecb15c25f7ef5fab21d9ec52cbfc4743bcf5198"
  license "ISC"
  head "https:github.comDNSCryptdnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38a991fd79def4d2ee222219c359c4fc1c17d40a285a770acffabf3699421e22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a991fd79def4d2ee222219c359c4fc1c17d40a285a770acffabf3699421e22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38a991fd79def4d2ee222219c359c4fc1c17d40a285a770acffabf3699421e22"
    sha256 cellar: :any_skip_relocation, sonoma:        "3964f11eafa485a11c0d7b7643977a2e9f301ef23cea1f16d09e04f251332223"
    sha256 cellar: :any_skip_relocation, ventura:       "3964f11eafa485a11c0d7b7643977a2e9f301ef23cea1f16d09e04f251332223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacbce7fc6809f62c43f35e400c771803a10ad1cbe95369939b8c0ce4cc097d3"
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