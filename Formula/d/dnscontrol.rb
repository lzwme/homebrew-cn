class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "0d17766a567d0ddd2d459a4ee9c7ebb787f3c6a7da2048b2d8c3563ee1b7108b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef8e38f4c14ca4eee85a3acfc1808c10bbba428e0ab0ee759e320b109359936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5dcef840d7a60b9d6bfb7c8e485e05caf8fa9344bec2fe5a7d2b8ff27c30def"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19ddcb6b05e4b9543ee8ef27c388bf8392a425a0442ef237712a8b59f309f7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5694195ab0969a16f080a2940431ccce5e56245d98651d9f15473c975fa4c2"
    sha256 cellar: :any,                 x86_64_linux:  "62773970ee69dcda9e4470f07facd5ee1d123bd6bb8ffd5153939544f9a50333"
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