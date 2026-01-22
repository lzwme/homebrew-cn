class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.31.1.tar.gz"
  sha256 "9bc7f62d2b8f295469cbd7dd36d74a3942f9cdb1984a1565b2eaf5c93b0d9ab8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d34f65a07b15103fb1dc549350faa585e56398626b796febce50d9a15eb9ff10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d2a56b0f9dee3c7d87aae4a6cca36de70487bdc2beebe7dbbc3147e2456022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465d51705221a04b462b4789775634e5b3b2e6f5e13697c67e2a4b6c8663cd56"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9ea74d81f54a2e1b63fcd341715d3f8ca83e79f128986c4bfd7d8943b1af6c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af556525ff3261d563bf637a5fcd7f7d2f27f13303069e99abe58e1beb45966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6a18dc06657fce1fdcdb060b79ae3ad3530d6766cba3a6a32d3c1f4b83651b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
    ]
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