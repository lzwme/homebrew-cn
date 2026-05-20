class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.39.0.tar.gz"
  sha256 "0ad3bea6d327764bc824c42018045441cfbdaa0a5e801637fc3effc3ee17bc95"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be37f6e517706563ec23215d108ef3c3555c205581e0f9cfc325d0e45a342e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b117719226e92451570f8c5e67f0dea0e48bd63d1fe00cb826c986fe769bc8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b3c54f78e3f06a000633277f5d606dcb92097b831d6b0aa23593f766a53375"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34f8cff6210270d1aeb22c17a2e6a93daa867d7aa135ebe8c9024baf02a7e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87bb3ccdce54d4c94ee8133cfa96adcf70d14b348923bb0357f4275dab906086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb10680ee280562cbc5504f7163dc6b1daf8be7c20b0bd8aed06b0c15feea4a"
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