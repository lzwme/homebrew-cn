class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.25.tar.gz"
  sha256 "b92c88597123b44a606ead8650cfe8201f720de481c2a9f164d6b86107ea3495"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b80e25d36cb07aa0b28b29ad796c64cc1cf539bba187b479ffcedcf1052941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83ee5aa3f0fe343189d2b3f71499142a2d1e21e44071e0d9f2415c9d4f69bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8cd40e1c919db78ceeed92409c61bebccda34b7e56779d33d0fcc96c8afef40"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb1fad2e724bafbdd3d35fdfdfcd7fb9999964e137fada240f88025c316c5fe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aa83592cf6d2730efd97ccb08617b03e05a8c750965c8269dcd4577efca1006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e865c8281710ff3c061985684ff01a83fe308e47aadc99e7538b8b3c8b82d412"
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