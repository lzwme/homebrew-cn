class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v4.2.0.tar.gz"
  sha256 "2e95199961d19bd48c6c22cbde1ea9bb597dfd56127ee32ee93ecfd4ea60882d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4e339c5327f44b90a37935ccb1649533fe4662264f9de1529b45e8f41b1189b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7322219541422e4faede138ef36d367f9d04a8bc3090eb2e1326c7019b6f47c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b62f9da86f7ce1fc763937009652d8e6f8946ebf1b65f6edb6c702fbc3f22777"
    sha256 cellar: :any_skip_relocation, ventura:        "91b4e7f7861bbb12163e88ef5cef9ee60e55a054ac596c3f0266043e21567a28"
    sha256 cellar: :any_skip_relocation, monterey:       "e302ca865eb7091350bd70593298743be44c5c41e281b6f234913ee7cc8b7983"
    sha256 cellar: :any_skip_relocation, big_sur:        "814ffbc5487dd8f4a663978d2ffbb3af7459e11e0c3c1f8e0932cc14ed9ce772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf0eedd2859646534f07a945655df4972f78fdb0e881ddbbdd9136a80a5c770"
  end

  depends_on "go" => :build

  def install
    go_ldflags = %W[
      -s -w
      -X main.SHA=#{tap.user}
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: go_ldflags)
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output
    assert_match tap.user, version_output

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