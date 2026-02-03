class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.33.0.tar.gz"
  sha256 "db30fbd9d2e91dcd7ff3e806339041073a15ff6992f4731dc7a0dfd4382cecf4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a809080f0f41edfb97f9f17d8ac63a407426ff44d8801d430f8e047bc5d83baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed2f6ca51e0088d6c2bf69a3e001c749ac431eb0c7ddc17c8e30a6a0415d3c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c673e9bf9a5ac036b31907fb06d4b1499fe50307c1dfffa9f4efcf56e6ba0736"
    sha256 cellar: :any_skip_relocation, sonoma:        "a596e841f7e1c67de1211c12944dffe652e2f365fb19847a01790709eca52fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaefcc08d8f82bfbde240fb6938be88062493ca7f2cc6fe3ef206e928afd7220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5513df3fa3078150c46c8195ff0d6a4c2b61f139186bc22bb855577e75da05ef"
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