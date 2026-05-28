class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.40.0.tar.gz"
  sha256 "48b476ce1914c5c779da0722099b6ca9e527b4c00b67ca55c04cb827d6663038"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "486f1ddec2dac47f59134dd69efee594f85097a4d4724dee48134e2829ec0f02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c855091b4b5d966980b2eb11de7fd4aa6b382e160af568ab51910156c371a0ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caac56163acd72b9db41923e2631046b3149b520b29c70e19475c032ab704d61"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b150da66f6c56023ea9a1c6a7bf092daf2b2d6a952b4518f3084e2da9681a04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a15bd82845fd9d5f91957f0eb6cd4526eca02e580443c77ca52335927bcc41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e568706cd1f1ec8aee392b17b28811531587302e359d3012dc0ab77e3a611f8c"
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