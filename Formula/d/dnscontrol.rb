class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.15.3.tar.gz"
  sha256 "c0322bd15392b28d18e76ffa148a2b8d4ae5923caab724fa89c3c08abc39964e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea4858b9480cfb627a7b5eae2152a879e828dec86b0a54d5f8f3af8665d24a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4858b9480cfb627a7b5eae2152a879e828dec86b0a54d5f8f3af8665d24a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea4858b9480cfb627a7b5eae2152a879e828dec86b0a54d5f8f3af8665d24a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a65b79b4398988dd443383e37123db989509051d11d767b77d629f70e40f50"
    sha256 cellar: :any_skip_relocation, ventura:       "f4a65b79b4398988dd443383e37123db989509051d11d767b77d629f70e40f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d03c44504ab276f395cd7e2823a6166ba2da8498bd3268da59af50e8a2661a"
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