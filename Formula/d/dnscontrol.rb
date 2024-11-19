class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.14.3.tar.gz"
  sha256 "47c06beb07ea7376588a40d23f73d8455a6ac13d5885b092bc29fb04fe3d6709"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a92087051f603c20115ecd9fd972747d4960210d49bb012a9af2976011dd40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68a92087051f603c20115ecd9fd972747d4960210d49bb012a9af2976011dd40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68a92087051f603c20115ecd9fd972747d4960210d49bb012a9af2976011dd40"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4521e9651b532a27d402cf690f3721b0001474a80ca0ba060d0ce619d1e34f2"
    sha256 cellar: :any_skip_relocation, ventura:       "b4521e9651b532a27d402cf690f3721b0001474a80ca0ba060d0ce619d1e34f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e00bc4deb96c83dfa54983078295babefb37f4b9622b8bbe3c97c833358bae3"
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