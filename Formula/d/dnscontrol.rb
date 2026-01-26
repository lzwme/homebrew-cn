class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://ghfast.top/https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.32.0.tar.gz"
  sha256 "584c713bd3d5b7cf9f9d4e1e3520fee23b0d8d70870ddc07de9a469bc656a03d"
  license "MIT"
  version_scheme 1
  head "https://github.com/StackExchange/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2b44d5de89791afb711400f72fec198502c8555f3a353c968fc8ec83fbfb997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9953eae0e5224d820abe89040aa2ce05e04a407436b480769185ae056fcde4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bff613dd06952d3c2e1176e687da5d6aeb2b08048ba6aaa13778a60b3bcc8da"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ebbddce1e83e93ac5564c4b3d5b8f09d98b65abf90443b553a19eeead28f55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2664f87a6068586c9c25e3c78a6e0cadf99177a8601067e7045ddd78cd29edb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd7f6b2e8ef9ea51f50fe1b7ee86b009f62e61bfca956672ace20d26b3bd5f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
    ]
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