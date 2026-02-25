class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.35.0.tar.gz"
  sha256 "a6e6c281f11941a3cb0f1f69ed1cb314fe78730647063255d6fd5d6f615b8186"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca55ff776b7ec8d88f9ae03222c4742ff47ca6ec06719a168acae6327bcf8ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be01968ce2b98a3920f6f09ee6edfebc8bd1b5def9bd90f87d130c089b9c2f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff36f8cd8730467d97794cc6e8a61b921529dfd5d6451eb2a263a5917a17cad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6db9b4830dbadb840cef620ad277eb495ece6ffc9237dc9750813734d85add"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a2e257f06b8a0e6a3fca55baf28c9d78009adddc5fbd676fbb5a80935e33dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ca6ecfed3445ccd98dd77d294377a7b6d3af54687943fdf06269943935afc9"
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