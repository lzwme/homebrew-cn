class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.7.3.tar.gz"
  sha256 "4d60ffb84b62005156b8b28d4c212a675946eb7bee557856517822e5bf2c1539"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2483de3b45967d4eacceed82f661d988e2cea776470dbf4c89b08b129f80c041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d68d79e9a4ef9ebef6002395c75565641a90cffadbbe88cede92c506e410d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5be258b393ac968552581931bc17b629f332a968ec2a209498333c7f5f8f84b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a4ab3bac86fe7a2c6fdcd9761f00a13457ba3ed94f54af5171f4a280e060c09"
    sha256 cellar: :any_skip_relocation, ventura:        "1a0effdf3e5a76a04b1827f6b51bea0d3ab6129df1f11dda327112c79363ae2d"
    sha256 cellar: :any_skip_relocation, monterey:       "f6ff80b8effc8973d7a2dbe777cc182fd3d829315f789a4c2b6eb1ff6b072feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49fad5ceff77ad1609922db92f314c349db1dc4001d626091e7ebc6ce1f73a98"
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