class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.15.2.tar.gz"
  sha256 "c833598de612f7682f26927e8bc0d16f10e4a7e6c0e88ef0c3a69edc5efcd08d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737ab13083318c984745f98c5b4421ab7b7c3cded702eb1a7efd90d1b193e60b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "737ab13083318c984745f98c5b4421ab7b7c3cded702eb1a7efd90d1b193e60b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "737ab13083318c984745f98c5b4421ab7b7c3cded702eb1a7efd90d1b193e60b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a06c5925d74550224542920c25fe0f481c4b2bc09c9ed21cc7825ed56013d4c7"
    sha256 cellar: :any_skip_relocation, ventura:       "a06c5925d74550224542920c25fe0f481c4b2bc09c9ed21cc7825ed56013d4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91b7d07f8a74519ee04bba9198b8e29b2cf73441414136e9e46c4ef592577e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}dnscontrol version")
    assert_match version.to_s, version_output

    (testpath"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}dnscontrol check #{testpath}dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end