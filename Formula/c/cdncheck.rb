class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.30.tar.gz"
  sha256 "b97a6a49296a5d1fc0702a478ce4f8d52ceffb2a3a40f91a3c4662d1c0c6df21"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd692a5f918aba76cb8b9899284018827a0f88cde6a48f123b6fdb8cb84574a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11d3fd16d19f80306f5e70d562299572516e3b3c8cf240c5a711ee7a9f85949d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65602c80da7f41325dbef00f5194bf1ee28ca37c48ee904f63c96ced8b124fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "506d04201bbe850e24a4719484088a5e033c78f6cf20218df64c863ed5c1aad2"
    sha256 cellar: :any_skip_relocation, ventura:       "cf4b76fddf5945de77d2c797046167d4e24457a8bb90cb0b58b02259affc0180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe1ac06acaf5e566c3c8493ec5d50e37f03c90e30ce50e8ee06d12dc179d97c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end