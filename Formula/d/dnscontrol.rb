class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.43.2.tar.gz"
  sha256 "ce30e8245cb072d456c26486231ebf6ba723bb88dfa1b2a664c456b49067d959"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c7886f0ddef035095648f37e75cd89b693f4590e855b73b207e38f931f76914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7174a84fd33eb9a93f87db7f10bc5b285728357fb64945a424953e203bc29137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "867194eda16af87908d03d1de98ad00c89ad60bb0051dc87edaf9d84a1d95ef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "59a4f6639a08d58339d451a9784498d5600319750aa10bbbe4ba00f5bfee2ed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f509524f9d97b3e952c75b17b4c5b366fbc39c7ed08acf1db8cc77bde739559"
    sha256 cellar: :any,                 x86_64_linux:  "e88ad2329b570c507735c07a9ead11e88995ec04fe723bd40d0ead35519c68ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}
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