class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.12.4.tar.gz"
  sha256 "9b77c20ddc3ff7f9a180722eac282abea790aa4f55b03e1d4ab9e865965b8152"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c69b5432df0162e4f6dadbaa1dd739c3cbce2c457fde744a3d5329fe261d9ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fd0cd774dadce7e244ae99381a82cc640e7497ab27a3cea649665ecf92d46ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f37048145dcd9cdf94eae9368e6b8a3327f0a5b28d478fe5d6f53f5de0654b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ed340f3e3732a970b55208616df7aecab0b2299b42c6b5851cf6312ee140932"
    sha256 cellar: :any_skip_relocation, ventura:        "50c38750a8dbde6f084c2fce35f817b45b0f7fdc710853af35fd3145765b1131"
    sha256 cellar: :any_skip_relocation, monterey:       "bde4a6d9ee091760d40ecdd7252c89ad62387681b0906cc81f9dbf1fef98edc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc94768f41abed46e0ee5877fa83f0a049d6947080dc752178d3b4f4f5b5ace"
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

    (testpath"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}dnscontrol check #{testpath}dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end