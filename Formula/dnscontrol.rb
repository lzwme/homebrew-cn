class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v4.1.0.tar.gz"
  sha256 "1280cf82b952afc5090f4e17008fd3eea417c417f1099470d4550b3eea8f8167"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2329ab7eb01ddf4d8df2c3b453cb3c05305f12e06a2730ba2631c026c45fb90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2329ab7eb01ddf4d8df2c3b453cb3c05305f12e06a2730ba2631c026c45fb90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2329ab7eb01ddf4d8df2c3b453cb3c05305f12e06a2730ba2631c026c45fb90"
    sha256 cellar: :any_skip_relocation, ventura:        "438e4e510b68eaf5d7e366b4a5754302a7050f9abfde6de6fdfecb94f39afd97"
    sha256 cellar: :any_skip_relocation, monterey:       "438e4e510b68eaf5d7e366b4a5754302a7050f9abfde6de6fdfecb94f39afd97"
    sha256 cellar: :any_skip_relocation, big_sur:        "438e4e510b68eaf5d7e366b4a5754302a7050f9abfde6de6fdfecb94f39afd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5840b9f00f45333bd27cde058b9cf0d67b47644302cb0e49201736714b4de40"
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