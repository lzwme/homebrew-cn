class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.24.0.tar.gz"
  sha256 "8d0106e3f10e8efc17e6f5f711ee67cc35540014acdcd10a6baa98712da6fb8e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cb415f15f851f8d3822232511217ad79378003533c29955782e0862086cb2bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cb415f15f851f8d3822232511217ad79378003533c29955782e0862086cb2bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cb415f15f851f8d3822232511217ad79378003533c29955782e0862086cb2bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f57fbf87e4eef855e6371d9ee361c7c0d7ef4bf8e0c6329f7bf1b192ee28a1b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f57fbf87e4eef855e6371d9ee361c7c0d7ef4bf8e0c6329f7bf1b192ee28a1b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133066c8d17cf42f2c9876c73c21f85ee984f6aa5ffbb67a83f3ebfe2c240cf5"
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