class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.29.0.tar.gz"
  sha256 "61d8ba871d2ff1d815bcc549e33c9fba283de8dfbd7e1c716161133c1fd485aa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a95322a71d1f9b7c4753ad47899539c0005a94b06711a843bc3056437fed68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b690c06a428653213656db2e0842f7b27a8b26b010dcf0cdd337f2ca35acbac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726603ef47d5d33ce12308558c00840ec0f2e9538ff922664e3803c57c391e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e100b00fb2a931e3a74f55fd4cb904efcc9863f26c9ad6c12570e52f3a0c6499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "316530a6137772749e20b604845e4faeaf23f7d1d17e9f16f2a8ee48e5d76113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac55292207581226658ddca1809fefdd75120f1314850aaf49259a1e5722e7eb"
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