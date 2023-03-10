class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v3.27.2.tar.gz"
  sha256 "3cc2cda0747046f959e518717d6d37336b617902bafc360e2cc3492503af9d3e"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac14d035111c92d62c26a65b0a581219fea031c82cd7a82fb6d340e53741131a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94047d3a01717e0779cb7c18d52085da1d80cb5d0375c05f4fc1bb7ee9a3ac3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fa9eada0ae376542215552b223db37e9f0c9c02102b9e8c9f78fc5230cb8369"
    sha256 cellar: :any_skip_relocation, ventura:        "1c24c0a2963c988cbe5ea03a7c09af65ff734d60a542c10206aa6e15bf4dcdb2"
    sha256 cellar: :any_skip_relocation, monterey:       "b07759b27ed0ee4064bb581c484c03c5183497281b440d1ad17de35441751b44"
    sha256 cellar: :any_skip_relocation, big_sur:        "51b4d35db1302af3a88e8d3e55ba35e83b9188ee5fdbe0601aa03601f8245287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7479042a7bfc3d4645c0a0ed41c5965333b1d4457b3c50513ffb9ab932184bc7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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