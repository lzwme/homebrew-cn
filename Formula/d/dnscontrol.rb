class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.15.4.tar.gz"
  sha256 "ef78e1c5fb84e13ba6ea80e9de4754ea89c5b756a445aec8b28d8ce65996f4f1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "120f7577fd8fdd277c0594a2dfb337310571f1418f84468d04a5b7bb2d531486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120f7577fd8fdd277c0594a2dfb337310571f1418f84468d04a5b7bb2d531486"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "120f7577fd8fdd277c0594a2dfb337310571f1418f84468d04a5b7bb2d531486"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a341c73adaf6c98023e9c3beee5677bb553f8f0cdb73c7e15248edbb632208"
    sha256 cellar: :any_skip_relocation, ventura:       "c1a341c73adaf6c98023e9c3beee5677bb553f8f0cdb73c7e15248edbb632208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22438d2237a69f80856573d6a5b1b1cdf011c37dde3eb51d10b02a67c0295ef3"
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