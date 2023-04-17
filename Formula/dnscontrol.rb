class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v3.31.0.tar.gz"
  sha256 "47e0606766fa973ffc8dd999ede2aedb80a1354107f7355da85154df5e0835a8"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132ac3d085f9769148b80309aed41a82a2fea2ed987d52ccc2102573dd6d62c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4a828a450cba25da87cbbc8d962c7c4ebe6336dfc24bc2b2336fd76ec821a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fc6ea9939ba6e520e01d68914d4f7827692fd96f18f24c742722475bbe65d26"
    sha256 cellar: :any_skip_relocation, ventura:        "43f8958374342fc36b2e4f20594b2241eb00c96e63c29ae6cf887def8f8b3fa4"
    sha256 cellar: :any_skip_relocation, monterey:       "24ddaca7bba367df0c5449afc17423830cb6d13fb0d49b437f183f904e6f22ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "3be4308cd60b5adfc6c85c815946ecc8c1d90da84c89ec9526094a45d1b87df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d7ba88e52ff58f44f39f325a5648cd4e0b75656430ee45732f3a38a2221b1d3"
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