class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.22.0.tar.gz"
  sha256 "3fac9a6e229d2c8d74f4b398f6d8bc2753df613a4d92010cede222333a295551"
  license "MIT"
  version_scheme 1
  head "https://github.com/StackExchange/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b469a7acdfa7d7c104997e2e6cb7b7248c5a26c6e1a498e721268bfc370cdcbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b469a7acdfa7d7c104997e2e6cb7b7248c5a26c6e1a498e721268bfc370cdcbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b469a7acdfa7d7c104997e2e6cb7b7248c5a26c6e1a498e721268bfc370cdcbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "03c5a51e60f372c457efe7ff3a580b41ec6093a55a8693971fe8c3ad09c11b4d"
    sha256 cellar: :any_skip_relocation, ventura:       "03c5a51e60f372c457efe7ff3a580b41ec6093a55a8693971fe8c3ad09c11b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c961dad6c7a1ce04c311dc8ef26c7296503631c6bda12009de5c68d3dbb4a473"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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