class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "43d730ac5c64f67cc00b3f1d85efe841e4efcdab1391550c15ef95fed552eaa3"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "401ce0f15718d36b907c1b0c38feb39818c451c01424c70e4d0535b7465bc266"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "749603a7fb98d3ab86b350c6d3035369e8b4c79f84f87baa6301c9f1ed08b270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36c18238830008bf947ceb5300c70c123245de355e2d34d684a83dfb9d8fda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "738d0df408296d7611675bea94fe51147f3ede35682a51dda822db7bb3a82030"
    sha256 cellar: :any,                 x86_64_linux:  "bdc60d632911d418254bcc4eb89a51036944526663a38eed51da8801e69c2a65"
  end

  depends_on "go" => :build

  # Fix the reported version, upstream PR ref, https://github.com/projectdiscovery/cdncheck/pull/518
  patch do
    url "https://github.com/projectdiscovery/cdncheck/commit/3b1edd544d27c4a34ed214b43a688103c60a3cff.patch?full_index=1"
    sha256 "af129ce7230e302c0b2379742bb05c133f2670430301b83adc14a6f56866e193"
    type :unofficial
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end