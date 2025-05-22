class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https:dnscrypt.info"
  url "https:github.comDNSCryptdnscrypt-proxyarchiverefstags2.1.11.tar.gz"
  sha256 "3f17d952843f48d80f91198e2bde7a12bb98f857031ca92085451d33f6c149fa"
  license "ISC"
  head "https:github.comDNSCryptdnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d58b77530ee3efdcd5e2eed71fb10a19db3d953080f008d7206cf126eede9d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58b77530ee3efdcd5e2eed71fb10a19db3d953080f008d7206cf126eede9d3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d58b77530ee3efdcd5e2eed71fb10a19db3d953080f008d7206cf126eede9d3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3a10d2ceed37149132a681e179585dea613c2f328ca00ace39830aec8f61463"
    sha256 cellar: :any_skip_relocation, ventura:       "f3a10d2ceed37149132a681e179585dea613c2f328ca00ace39830aec8f61463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88c17169e3ed2b6917a1f2a63ee23df9bfdb6167cffdc495cb00028f7b9d1c1a"
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