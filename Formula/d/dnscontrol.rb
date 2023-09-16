class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v4.4.0.tar.gz"
  sha256 "7a13ea6772b683f46bd1b23f567c381cf58d1637c6fa7ff65fef29b79b54667e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3786ad5b01a098849de36764b11c6fe473b88f1002ff1dd3e2f8189fcdcbaf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "239566e6f107e89e44c82c91ec9f79a76755bbd5ce8225e36426de93856ee305"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b87e00736183dc545775a4c882a730970445b04a42547457c90842f0d9567d9a"
    sha256 cellar: :any_skip_relocation, ventura:        "bf4fa48c9dccbe4950de327d3ae94e12f0561a939ca7c6f7f4d96a88ebb965f2"
    sha256 cellar: :any_skip_relocation, monterey:       "9446223dfc1738d73edf5999a27328415a0206378e016fc3c3884c42ae4f07c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed8ab9295e3949bb75882223fb85ef6daa1e6a1718bd3ddfbb7dae04629dc973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77f9fba5c461adbf6c665bfed130d1fb4edc28e3f407bd8c97f8fed028fe883"
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