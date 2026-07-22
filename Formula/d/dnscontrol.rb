class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.43.3.tar.gz"
  sha256 "0a8027cb703ef2dd329b81794d2b64cd83edec9b1b60873109d5783c7289a9c6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da57ed1cb9e50c82889a77efce48f58c0f65c7bbb74e0c69ae3dd444f1a4164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f4332f820ef071534f29c1f4b94e4626672453d55030b109a64de99d9f13f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c239d70b61e76c8777d12332ac2ddbad7711b602dddd7122dfcd66c033fdc9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "22132492c5a63f312d0ee34c745555ba884eea883955c74cc1b89d3f3bde9d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ae112ce58d873da23f2348073292be1614bd8fa5c10ca46eb055e2a0bbce2c"
    sha256 cellar: :any,                 x86_64_linux:  "57266a0b73c6b7868f371cfcd4ca3f56d040641dfa01442e5dce16355c68b57a"
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