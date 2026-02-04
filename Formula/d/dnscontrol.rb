class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.33.1.tar.gz"
  sha256 "4719d39698925d2750d98fbf967355ef61c3c4ff1e992dc34f68641635314e01"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "645153ea435da2187b6753f21ceee90413bc8a805f569ddf7b714e61fb0e8523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f600227ff70144ef85a281658da42326daeb9b0fe219ea02e17580271f03e0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa69ae58b3f31b0625f7e53ab4711d32c9c209248770c0aaaca162ef65d5c375"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd598c7af51ddb546c1375e19dac8ffa1adca95e1d4908db8da17d2d44328469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d307f78c7827c41c24c7a594847f2963df0e33934ebe5af8ef0367119b6e0634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ccdb93334d11a55110b74495d07ff7610574be285cfcf02f37f39aedb97030"
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