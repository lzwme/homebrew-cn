class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.26.0.tar.gz"
  sha256 "432237fae9991160311a3c20e0d6e6c6e1b8ac9bf5022c899a2e6a75037298b4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b706a5ecb6c698a3285751389286e6860644340e682c18a33038de32359be836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b706a5ecb6c698a3285751389286e6860644340e682c18a33038de32359be836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b706a5ecb6c698a3285751389286e6860644340e682c18a33038de32359be836"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad072db9af3f18dce27a8602a3c063b76d4f3afb956a7096f62fefff153decc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b092071f027d7da03724dc5c0de9fd6264b17571d9e2b5e923071d6e0f8ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe4016f5b712ddd6c82f1ef525cd7bb4c285c6572881712234fd4a09c9b3583"
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