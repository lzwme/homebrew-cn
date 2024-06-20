class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.12.0.tar.gz"
  sha256 "c96e9fd2c131495bdb9b44783ffcd303b501198e4486e95a8624783209c3930a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3c591c9309b436a538a2b2f57e45ea093431b527be3b6cc6c764d8a4062b0fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8d3947703ec0e93abdc0c0c1c71657462151d16c97a94f5e29339ab248b239b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6a39ee35d38e3d2c798dd20e8bd531b37d4b5f36792ead74f1f157738e1b4a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d299fc5523e71a2537ac896bc6fe44dab74961f2737347e9a234d1b6c5cb2e"
    sha256 cellar: :any_skip_relocation, ventura:        "30bfb258846cf4bdc24a66ed09b98cf1a16bb9391f7d3f0c986507d645193845"
    sha256 cellar: :any_skip_relocation, monterey:       "25b4ebd1d0e5abdd3275c12e84c4480c25850f2281bd2105b3c0d67590423916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f573f92c5ec48514fd7f4041fa70ddb4aafe05a6b1d1b0de4f48e14e708041a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}dnscontrol version")
    assert_match version.to_s, version_output

    (testpath"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}dnscontrol check #{testpath}dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end