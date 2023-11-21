class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "e262f512849cdb497623c8426d28f111c4dc136e9f1875522306eaa567994cfa"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05919e5f916c8ddc3fcf5673e0aaeff4d24ea08b118fcbf807f984f4b323f9a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2141fc03d5481da59343545d97570230dde18d64740ecf7b289d271ab19c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5257d3ef3b8ba0612ea7eeb818c52f8dee23c267e6bd0de94b5d5b5f83f42013"
    sha256 cellar: :any_skip_relocation, sonoma:         "48b212adcb6676a6e2abaff6bd5d239e38bc182fdd98a38273031ed3ffc29a73"
    sha256 cellar: :any_skip_relocation, ventura:        "77f5d3693a958fffca07024218d06459592d1bc4b7d33e7d3cf548a2ca02e0a9"
    sha256 cellar: :any_skip_relocation, monterey:       "02be9dc5b82814a93a562aca4a86415233a4079e8320bac5a711d1ecfbc269e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb228cdfde81d5c69012bff8d1011d3c083d8ee392d327652833b1f2956073f"
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