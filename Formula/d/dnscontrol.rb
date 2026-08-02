class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.45.0.tar.gz"
  sha256 "d908f588aff3a5c792cf2077172b3f28ae64179ae12a5e0c822903bad28d4cc1"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e05d96817231140091a72de6402ef71c26aa6dee8065c943bce32d09cbc33a76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7595d75a5bc929ee0a99cb7d3607655f44b1cd2b1aac6d3e356385a4242420c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84918d67402beeb4449bac2feffad58b410e92dea871a45a4091c300abd4c7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b332c0b59de6e4f0b0f8fed1612750bc4eab8333a9ffe86a5d69af158fc83a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6142e74d7892ecdcf0750062103008e5657931c184a337b36c5b8695a004668e"
    sha256 cellar: :any,                 x86_64_linux:  "e974906a079db75fb6c41de6e77b5cc5b9a659f050145b9d8c6488c9c9e0a80f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end