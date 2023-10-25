class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "57fd885136e4e1ea4e06dae0b9e2dc78917485079534018595d5193a32558800"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b7578c319b2d6272e722e3e4fa4ba6ea18cacb119457608179b1e679c069d4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3017d2878f327b0f8cfb243611a55c2b8e48c47172bdeee94d07428d5ab7484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eded1cf14ba9da919e334f902b1ad503ba9db056cc1986ef6594879ebac7615"
    sha256 cellar: :any_skip_relocation, sonoma:         "0528a1aeb82e5a9f87ab1e6148f1180e6711050fc30578723386876e84a6826b"
    sha256 cellar: :any_skip_relocation, ventura:        "a02d4fbbf5d5d3e0dd2160c216f824e0bf3e87f4b6302979767f68a5792951d7"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ae764135243d137969edce9f7a9973988d33bbec18c85e4c9f961d3e38e6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2661d0fe9c9475b46d96e1e49ba2238149ce1ab9680db40c9b3ec751ef4dd27"
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