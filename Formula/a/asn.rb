class Asn < Formula
  desc "Organization lookup and server tool (ASN  IPv4  IPv6  Prefix  AS Path)"
  homepage "https:github.comnitefoodasn"
  url "https:github.comnitefoodasnarchiverefstagsv0.75.2.tar.gz"
  sha256 "b3d2f768f296bd8a8e6ab9f8e28287915390feca661d20110518c79580871b00"
  license "MIT"
  head "https:github.comnitefoodasn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "baa02015b1f3bc5a444df56681901d0a91af52616ea102448b6fc9ae29039f1b"
  end

  depends_on "aha"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "grepcidr"
  depends_on "ipcalc"
  depends_on "jq"
  depends_on "mtr"
  depends_on "nmap"

  uses_from_macos "curl"
  uses_from_macos "whois"

  on_linux do
    depends_on "bind" # for `host`
  end

  def install
    bin.install "asn"
  end

  test do
    test_ip = "8.8.8.8"
    output = shell_output("#{bin}asn #{test_ip} 2>&1")
    assert_match "ASN lookup for #{test_ip}", output
  end
end