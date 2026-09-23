class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "ce287f88e7888832711f1cb5ed955c3d2b5de362b29c9753c9564ed2e897dfd6"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39735eaa5c6baf6f09d9b565ceb7c9f86956c1fb89352a88d4cad3754360c79f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a79c3f120222be634ada21c812e6337f83bab8652c4dc7856d076af221075746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcdf2013d104d1e93a39dc0b5307738d07ee7afff4716adcf2d7c5d12dfe2eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02f05b64d009265ca2bdb739022535de66e6d1f622ce834b3b491149675162c3"
    sha256 cellar: :any,                 x86_64_linux:      "e2926ae392881a23e1515297cadc184b35e8759059556400ffe885f222b44dcf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end