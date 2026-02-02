class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.21.tar.gz"
  sha256 "7703631d3d727d9ecc2969add4474053d42a412c0bf284931efbcdacec94dedf"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f52cbabbbec8a9c0a6de70e4133efaebe5ed0b97d5665a2d559d82f4714766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2e5e11783233376209528197f30278302f875e56a19c879f79a2ad377ba7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db532565df9542946f45a6b0e04a04a47c43004f357424ee295af34497118607"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3a8187bc77b7f89149027446309fb524351fffe796b4b39fd9313017076c70e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0a131b163a5ceba5cef06efc8185ecb35f9b4813b2a54c5cb61996190e84e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bed58465894119263e7ef22789c896e508125642604df1cdc6622d3fb86e5a"
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