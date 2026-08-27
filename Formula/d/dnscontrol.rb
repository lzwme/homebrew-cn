class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "a7f2ea699f52f2fb9284e5c0be6569f2bad421563fd141963e23cb3c96ffd665"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4832376e8246fb455b2001bcba74f83c9031ed3b5e0f3aca093ed9f03ecfc90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803a9b94eb154b67be3394ba73e14791474360442f10915f97ab1aaf666edcb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219cdbd558d12c71a14c271bd895a833b0a88c485f46e2298981bf02db615e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "36672b0e651766f7f566de4ff6ed7ac30686af6c711625109784b5ec2bab3a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedfd91e98d0599bacabba726e627950ad1634f38f698d2f3756bfb490dcf292"
    sha256 cellar: :any,                 x86_64_linux:  "4300e2396e00b68238a8c036c177bd39473e735d5ad42e4da0257f1209bef502"
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