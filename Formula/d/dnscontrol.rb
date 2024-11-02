class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.14.1.tar.gz"
  sha256 "be498ce81e18bce01f9f2585782d1b2d322095b259708818e3ff63e0cf66f951"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc192182ecbb9fcfd41dfbcc036cd8ed597a7fa04fa207a59e3565848547b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdc192182ecbb9fcfd41dfbcc036cd8ed597a7fa04fa207a59e3565848547b7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdc192182ecbb9fcfd41dfbcc036cd8ed597a7fa04fa207a59e3565848547b7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99d005fceae100d61e97a817885f55dfefe774927b27201fe9711e9cf972142"
    sha256 cellar: :any_skip_relocation, ventura:       "c99d005fceae100d61e97a817885f55dfefe774927b27201fe9711e9cf972142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1117647f52f142d32ecd77194a4a8bc29858246f4b0eb1cbddf0425e694ec51"
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

    (testpath"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}dnscontrol check #{testpath}dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end