class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.15.1.tar.gz"
  sha256 "15a79e8673b66eaf4bbf2494ea066b1b8fd7d481a5216277389338a4a90b625c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "509b816c4621e8e8684d536396046f71fa08ccf0210c966a2285bed7922563f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "509b816c4621e8e8684d536396046f71fa08ccf0210c966a2285bed7922563f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "509b816c4621e8e8684d536396046f71fa08ccf0210c966a2285bed7922563f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d320fcf06d254fa43ecdaab929340eded40df3be528da4372ca1ea8c4f63a84"
    sha256 cellar: :any_skip_relocation, ventura:       "5d320fcf06d254fa43ecdaab929340eded40df3be528da4372ca1ea8c4f63a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648b827cd040e3aaa51bec66341e631eebb506152e58c2bdf37a1f7ddad3ca8a"
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