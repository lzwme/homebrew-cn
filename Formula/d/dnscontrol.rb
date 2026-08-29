class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "0762bb5979dac5584410921d21b750511b6d296c9bb40838e5d3f83e3a964d69"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01da977dc9addf3821ac2e328fa1b62e3e09fc2194506331978affe03b891ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e610ce5d6000f397bd070ca88517205b93140bf6ee29f01d22872bb9586539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a087c86616206da17ab06f1900c0b13a4c0895ddf5163b8faa216fe3c0e50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7559a5ad61e4ce2568069aa46a829aa77bc4cec00daf680710089a1cf190cfa4"
    sha256 cellar: :any,                 x86_64_linux:  "da68334a6efa81858f53840ca57b7991afef2f2e222e2ed079991c43cef47c85"
  end

  depends_on "go" => :build

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