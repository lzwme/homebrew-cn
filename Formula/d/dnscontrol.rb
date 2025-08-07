class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.23.0.tar.gz"
  sha256 "f21b54499ad4e1b15008a385467b10681f406cef3c8bfac6c980f26ce199b899"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711c727955516669b871a6754d1a2171cf96435e4c3ca0eb9afffe32bffa2054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711c727955516669b871a6754d1a2171cf96435e4c3ca0eb9afffe32bffa2054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "711c727955516669b871a6754d1a2171cf96435e4c3ca0eb9afffe32bffa2054"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3357190fdb8e8c45e66ad3e246099a3865e8c421178ef670aaca8649260d52"
    sha256 cellar: :any_skip_relocation, ventura:       "fc3357190fdb8e8c45e66ad3e246099a3865e8c421178ef670aaca8649260d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a637b2d061bd47348f46cc3c776115b779c79117b257d75d8ddbabf06ea9b715"
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