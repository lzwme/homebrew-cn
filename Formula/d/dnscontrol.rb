class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.16.0.tar.gz"
  sha256 "ce9aa8887a8cad28b17f8e07f0755730beadae70f48976116ad8be7390cec3a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247e1cac6d47014aea0415360fa39e0b67b00de9ed4a6e3de33d532730e34e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247e1cac6d47014aea0415360fa39e0b67b00de9ed4a6e3de33d532730e34e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "247e1cac6d47014aea0415360fa39e0b67b00de9ed4a6e3de33d532730e34e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ce57bd397c1ceebfa6fa799a62157bb1385e27fdb8c5ef27003a2ca40fc2eb"
    sha256 cellar: :any_skip_relocation, ventura:       "72ce57bd397c1ceebfa6fa799a62157bb1385e27fdb8c5ef27003a2ca40fc2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca61b6c4dd916e84038a7ef16bf4c180afd458bfd131af1b246d5e66e141a51"
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