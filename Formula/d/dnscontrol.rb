class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "4a76b675ba797cf9ee3200c33c0452fd74da429b93b32bd4a56e00307ca4d6ef"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4c05ab4737b16c11cc892aa205fb8f8ce4d68f6fa0da409061eddaee0a5fd8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4273439b772de93442ccfae787939f2d8b211106685b3b97bbbfd1e78913207c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29f5321b438759c168355572441e1d516aba4570f24b023e8834313cedb74155"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad267d729be7ab441998874ec1838e2144f31802f5f948aee2441404669d95b0"
    sha256 cellar: :any,                 x86_64_linux:      "72a889311166f4e89e4aaadd01ddf4d0b723d2195738e2dabfb25cc068d95f2c"
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