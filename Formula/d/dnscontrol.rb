class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.14.2.tar.gz"
  sha256 "d31e488e828524ee083e170dac7bd9d0d144f3ae112e2be73ec7abc68a5789f9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48050b08b80e7aebb5029d12cdae846305dc0f6425f016b538c3bed895b1be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48050b08b80e7aebb5029d12cdae846305dc0f6425f016b538c3bed895b1be2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e48050b08b80e7aebb5029d12cdae846305dc0f6425f016b538c3bed895b1be2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f31f49cb1a618d86fb0464cb160b7a701ddf066a9ce6499d6a68f1d8146ba8a"
    sha256 cellar: :any_skip_relocation, ventura:       "4f31f49cb1a618d86fb0464cb160b7a701ddf066a9ce6499d6a68f1d8146ba8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edc87a502813053545d7dd24e82c2193103d74c332f3980d50b32815b09f6ab7"
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