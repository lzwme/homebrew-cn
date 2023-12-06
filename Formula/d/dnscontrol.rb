class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.7.2.tar.gz"
  sha256 "c2a9bc46b8f88c12184a03d685f8cb826f0639a8c93546941485a656208a3891"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2b1dba9d65b87e67c08692bde8829f9e089c0b8534cd7e3a741227fcbacc524"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345cb359fca0e273264d82e4c200340cd238275f0329105b65004e7038ffa09d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30eff5275d0b841ff315b34e1a2cf18e772e0dc07a908d95eaaa2523c3eb43a"
    sha256 cellar: :any_skip_relocation, sonoma:         "453bd4fd58c70bc2696c829ea9bdb92a6ef1558c54ad23d27e769ccb348792aa"
    sha256 cellar: :any_skip_relocation, ventura:        "8972805a05a7c2a1fc32608260c76010785826fea91dc9f5784bd3c3b74b9361"
    sha256 cellar: :any_skip_relocation, monterey:       "59ed73f7495aeed4998acfaffb7920a0cdbd6d868a332f531f3fac0f57554d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073f03abd17228e47e6db6bbb2f029ee8367d142633a2b94add38f52656e7183"
  end

  depends_on "go" => :build

  def install
    go_ldflags = %W[
      -s -w
      -X main.SHA=#{tap.user}
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: go_ldflags)
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output
    assert_match tap.user, version_output

    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end