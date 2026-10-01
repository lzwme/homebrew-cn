class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "899a3f4f1a5adc8c77ff476fa0abbc31c642527b6c53f4325c1e653ee5aa970b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03d8cfcadead19d26f18ffa72f994db27a8142d2a67c9070bbdea38e189b8b45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f87c86fe3069671a9fb7514c077e1d1cf9b1a05d46b5660606e2e36042a2a4a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16827bb7720fc91d6dd9f9aa1abea8a856088592f528088f3c7c0d706d5d2158"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "048a3f646ee0efb492178dd0ba346217417725623f74e40465f318f2189076e1"
    sha256 cellar: :any,                 x86_64_linux:      "a86e6b9e23a4a9909e5ba48c29e2078fff4d94529fc1fd9493f3126c07e2872f"
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