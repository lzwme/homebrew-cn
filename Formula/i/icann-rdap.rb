class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://ghfast.top/https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "2a675b661e5a5025e16db1375447d78868dc1273b90a8d806a2210746ebc9da0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af48d816e46c2fe3b9d69c6444ba6ec65981210e7ed30d76fb9b61e87f884ed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51801062d4cc60310348ea9e7ab644d5bec0f144ee9b003ff42264509081b51c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe43fa579c671d69c83f60472700b7ef44db5d1c61624a4888676baa54eff0d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "670b398154dc1426f7e1dc1c9cc1a6c9c33211aee404630df6e4b94bc7a1679c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1b9c8131c1dc1e703d86f63c0360ce10c6b9f323a4e96359cb2bc98a478862d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40aa960140b12a62450b1cda8c04b48dfa51f008e430b095962e20191a711638"
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
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap -V")
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap-test -V")

    # lookup com TLD at IANA with rdap
    url = "https://rdap.iana.org/domain/com"
    output = shell_output("#{bin}/rdap -O pretty-json #{url}")
    assert_match '"ldhName": "com"', output

    # test com TLD at IANA with rdap-test
    output = shell_output("#{bin}/rdap-test -O pretty-json --skip-v6 -C gtld-profile-error #{url}")
    assert_match '"status_code": 200', output
  end
end