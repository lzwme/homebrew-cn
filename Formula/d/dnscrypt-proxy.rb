class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://ghfast.top/https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.17.tar.gz"
  sha256 "06f59c64e2aa6cf7916c335cb57b369ce55e2d6e7fa01803e0da8f6728e3196e"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "178eda8fe9fe82a7b461a9f0a292ca05eebe2316097db215d1e8f4f9f7aaac24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178eda8fe9fe82a7b461a9f0a292ca05eebe2316097db215d1e8f4f9f7aaac24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178eda8fe9fe82a7b461a9f0a292ca05eebe2316097db215d1e8f4f9f7aaac24"
    sha256 cellar: :any_skip_relocation, sonoma:        "d05a90062a1627ad2d53d366e5c450d2433e4478926ff65f7cb22fc9920b5ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d97fdc1a45c69402870e39c283b0b43bab46328f72544348a088df87d7a7dd49"
    sha256 cellar: :any,                 x86_64_linux:  "008827e45eb56c6108f6bef01abee02be6e5744fadc8c7a3ee20f8ac5a0bacec"
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