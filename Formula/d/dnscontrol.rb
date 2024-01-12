class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.8.1.tar.gz"
  sha256 "4191cb4aa609aff6c24c7cdafab3283a6cd3f45ba460e33992ea3bcd405f5598"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbbf2f5939b324be91bc187a108f81891d27d41f80b10280c6a9280dddc43341"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfd48d3584f033ece3050e6169905b5cf962818cab139cd4d0bb70bfc7ad5251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06c68bc2f44ca2397e63b574e308f8d9421b95e2237cbec7e357fb43fcd1569"
    sha256 cellar: :any_skip_relocation, sonoma:         "f118cc0b7fba5a84b8f9b0aabe3c321baf7bd9d16683dc11eeb9445c095a37ce"
    sha256 cellar: :any_skip_relocation, ventura:        "2850f93be6550883339d84b5b9056119f367d049a2cac79e704089a348bb042f"
    sha256 cellar: :any_skip_relocation, monterey:       "67237f966ffe21fef77c796bf98e24872861d3d48a449afab7b29189568aa4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faf8f6b801ba69cec807d3b5acbde0e22e5e390f691f52d2d60ac520daebad53"
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