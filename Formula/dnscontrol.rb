class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v4.0.1.tar.gz"
  sha256 "27ed46ac140ed1f31557d90f4d931eb9bbd8b804e34b32e3f9d17590e2b32825"
  license "MIT"
  version_scheme 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b25d3b2728951176f90755efacab400c38b34e0b3a6abc0c53a19f8090318a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b25d3b2728951176f90755efacab400c38b34e0b3a6abc0c53a19f8090318a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b25d3b2728951176f90755efacab400c38b34e0b3a6abc0c53a19f8090318a5"
    sha256 cellar: :any_skip_relocation, ventura:        "6acf03920003098fe8d3ac391c40ab8e541c76959e4b7410b1466694a64eda84"
    sha256 cellar: :any_skip_relocation, monterey:       "6acf03920003098fe8d3ac391c40ab8e541c76959e4b7410b1466694a64eda84"
    sha256 cellar: :any_skip_relocation, big_sur:        "6acf03920003098fe8d3ac391c40ab8e541c76959e4b7410b1466694a64eda84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3050230e2af0035973a08547a5df529f2832abdffc4de94b8f2bf2a376cba3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end