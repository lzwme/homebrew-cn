class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://ghfast.top/https://github.com/nitefood/asn/archive/refs/tags/v0.80.5.tar.gz"
  sha256 "e783d2c7837fca9ff60812975f9d98717493eea12dea5ed4e9036074542966a1"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "125b4941dbfd29635057bd63f158c7c92023e1ffa8e31e5e6336ccfbd3b3ac2b"
  end

  depends_on "aha"
  depends_on "coreutils"
  depends_on "grepcidr"
  depends_on "ipcalc"
  depends_on "mtr"
  depends_on "nmap"

  uses_from_macos "jq", since: :sequoia
  uses_from_macos "whois"

  on_macos do
    depends_on "bash" # Bash 4.2+
  end

  on_linux do
    depends_on "bind" # for `host`
  end

  def install
    bin.install "asn"
    man1.install "asn.1"
  end

  test do
    test_ip = "8.8.8.8"
    output = shell_output("#{bin}/asn #{test_ip} 2>&1")
    assert_match "ASN lookup for #{test_ip}", output
  end
end