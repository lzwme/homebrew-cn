class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://ghproxy.com/https://github.com/StackExchange/dnscontrol/archive/v3.30.0.tar.gz"
  sha256 "decec616a5364c9b494a529b7ba2e6e6f972ad7a47adfde455b0ea30e4ce4626"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1dc9d3ea60d99323c4b26dc0ba84068466a4b694a7da5b3b8131eb325a6e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85f323c74656eb9da672eb644c1751a0ae6d554900087b2f3343bbe724a569ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a56dd26f97b1f437189015f76c46af25343f0695b97fd7c97b086398d94a32a"
    sha256 cellar: :any_skip_relocation, ventura:        "29e09cb96bdfba4b0c464f3682b1c97e68fed00826727de80d358253774186e1"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a22027be6cd61cd3f3f91dee14760d7a66e0548c9517ac09623ff7e2df4228"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa6b559376e158aaec81029e0473706fa560c85dd034de4cca564f48f8f0120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63fa79ce8a6b62718f3a795079e4a90b3ff182fe62a594d45becfb56eda9e4d6"
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