class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "9fe049d0846a0bc56efc9b9ffcbfd271f0bcbda1af736762267d8103313d5fc3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fff41e76dc42c435a65aa35abb70a84202b4622bb5cda5fb8ef31301907278a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "765ce5735357726e3e5ce69b61f5bf2a9a924929479678cb3eb6b37f1b53f6a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b008773c284a4e873748f5d8eaec6eb3cec5ed3df660ee85769e6ab9a1397a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66b615b4de16188bd4de816babad3267afe490c4b9de8bfadf5e78108f3e11c5"
    sha256 cellar: :any,                 x86_64_linux:      "1bbfaaba1e81fe5b95bb4fa3c087d595186d49d5d8fdd3f9ff8c2c359f7a467b"
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