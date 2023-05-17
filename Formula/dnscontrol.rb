class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v4.0.0.tar.gz"
  sha256 "755a78da2a3ce6f55b4116d1f4e3d87aacee2722e77dd0e9af7584b6f1041e7f"
  license "MIT"
  version_scheme 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34c81f5eb0ebde9c82d86a657947b4d62d9bc01d8dd078789418aaa6120bb70f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34c81f5eb0ebde9c82d86a657947b4d62d9bc01d8dd078789418aaa6120bb70f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34c81f5eb0ebde9c82d86a657947b4d62d9bc01d8dd078789418aaa6120bb70f"
    sha256 cellar: :any_skip_relocation, ventura:        "76483018442f71e487184fba44fc22819074110c8279bccc14c87310d5b82af7"
    sha256 cellar: :any_skip_relocation, monterey:       "76483018442f71e487184fba44fc22819074110c8279bccc14c87310d5b82af7"
    sha256 cellar: :any_skip_relocation, big_sur:        "76483018442f71e487184fba44fc22819074110c8279bccc14c87310d5b82af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9333a1d81502a55a4b88b80bb5ae3ce5449a1a2b58d40e39f29c18d7571902"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end