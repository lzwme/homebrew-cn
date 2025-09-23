class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "19702364291050bd4be214ea2d42394aa971cbc2441cad15a8391f96cfe4907e"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "875995f27888351ec9208b51a30d22413825a8edc25ddf2dc0006e91e2ad7f0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00b5786e645c81816f4d4fa9badc3a1f98e34ad5e5809f21cfc61e7656b4cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c677e0f386c87f269809769eff71f003ba1d0bfac97c31c1f1e43816634af49"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cf6e28204ca34c0ea03755fd4fba88c1083d0ed2ff2d21f90d8465d656b5436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ddfae7b4078b14e439ff09259302be075117c22406d04a8a65578155c1b7cc"
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