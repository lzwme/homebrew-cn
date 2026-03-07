class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.36.0.tar.gz"
  sha256 "04233976841cefec006f993c3efb78280a0bfb32d00198f0e01c8128601e1db9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd843ca25a591c9fd45029b24d4d0c6ff1d12d66c7d92eb22a778d1ad30ad9cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "533fac684a1204f211a86a36d71104c9bad260561d7e047957a58b132c2252af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0f5f37e5c6f7c1b03aa8f6b3d0b937a4b4350f583653b1e6e07ce900e56cfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "24555159a280c999a5eb82717d0a5d39832bdc0367780308341b6c81257b9326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450f6825bbeb979134710320fca31184c45eacdda1de67bcbea277e8226c0f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67f6ca613902dc240d605c9085623f5bd1d505c9022f4b1800fd50cd1afd5d83"
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