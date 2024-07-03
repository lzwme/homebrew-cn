class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.12.2.tar.gz"
  sha256 "954d8bd5cfd4da1eb1f754ffa0eab47e959d265d227e591086457c5182efabec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "830bafb50177f36e0119d67ec9683a5c996cedf360df9e40877759ab8b37a613"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b900ef71d62c20928b56b0b9c8978138a0331fa6ff9b3af34c925dbc4ebe71bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "678f1eff2f1ee1ef208db8a759612a46c47f8b67d774b23ce8c4d6da3f1a81a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab06c5255b875460a979da3647b1343e9ba2f555f75f48222a13f004af3abd3e"
    sha256 cellar: :any_skip_relocation, ventura:        "1dceade49ad3fd34515ab3e52f09a0aa283c5ae48efcbc13804cb1986909fa8e"
    sha256 cellar: :any_skip_relocation, monterey:       "3f5a729e6c29ff2f2640833ce0c76cd507fa4fb0ac18f80d4ac0d86ed4e298c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e8d02004ee18fcd9b1a6de34c0c3ddbe91bf20471ff9e9d90f7c00e61b255e"
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