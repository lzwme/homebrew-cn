class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https:dnscontrol.org"
  url "https:github.comStackExchangednscontrolarchiverefstagsv4.12.3.tar.gz"
  sha256 "88696f622e614d687caaa592144a57e32cdb6e36712cf4a57a71860cb5ec45cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08a7b62266cbeac63cf034a437440a0be7784e60ca1ef70c4f359593e36bfd8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ff984910af6bebe8e871d363407417d19a2fd794b07d4a717deb12978c528cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9050d11690d9c7e1989690320fc3f57c562b54e210da25b431f6f72452a857"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c113a373c66e2a0259502d262a7ef1f8e6d01208da0b0c3803fd8e27440ea9"
    sha256 cellar: :any_skip_relocation, ventura:        "1c8d28a52b5d4e5e52e33e52250b0cd6d5f17b1969774b6888260d888cac5815"
    sha256 cellar: :any_skip_relocation, monterey:       "eb96eebcdad1f85ffdfaef9f4dda3c9b3055f7fc0df2a725e38f17031d1de53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a72126beba7f33c303c35e6f901c29bec0710dfe97a85d146fe1aab285995f"
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
    assert_equal <<~EOS.strip, output
      DOMAIN: 4 example.com
      No errors.
    EOS
  end
end