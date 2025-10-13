class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://ghfast.top/https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "53121b4caa1bdbc61ca2a122b7b915035553618616b9c47095821a9391aceddf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16e55b9c027e263c8147292c3c167c6ea5b3c5a7e13f71b31655dda40c40b6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33db490d8b3e7c57f37797e868c17da4da347ac45bbbd8094acfeab8ca230c01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1b9c95c5987c03252f33030c4ce6481acd5694d8cf0566c8d6cef1a6e671b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "02fd2330a651c23be064baaee9561b931c25bea59159c325f0c05095cf558ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b3159322121509fa0602a3c3203fe222758b75d583f2db2f10aff95bd1438b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dcbc0ce4096d9f2e7caf3ee61d383e97e1ef383f1558042935fd126a612f732"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  conflicts_with "rdap", because: "rdap also ships a rdap binary"

  def install
    system "cargo", "install", "--bin=rdap", *std_cargo_args(path: "icann-rdap-cli")
    system "cargo", "install", "--bin=rdap-test", *std_cargo_args(path: "icann-rdap-cli")
  end

  test do
    # check version of rdap
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap -V")

    # check version of rdap-test
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap-test -V")

    # lookup com TLD at IANA with rdap
    output = shell_output("#{bin}/rdap -O pretty-json https://rdap.iana.org/domain/com")
    assert_match '"ldhName": "com"', output

    # test com TLD at IANA with rdap-test
    output = shell_output("#{bin}/rdap-test -O pretty-json --skip-v6 -C icann-error https://rdap.iana.org/domain/com")
    assert_match '"status_code": 200', output
  end
end