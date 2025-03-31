class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.12.tar.gz"
  sha256 "c006eca96b0cf49819db7d09942a5735eaddd976a4aa3d127f9d5aeb97ab71bb"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d06914e09ff887724a757bcf06fe0d794c22e9695ece1266d969882bb1617234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be85b0cc70086732dbcaf2cd32b8e74e211ddbdf33b0dcdadda7b946c159d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bb593d89ec98d2c8abe1780131946bf637c8c71d7321c21a27d671d1228f304"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6d9a981963a1e8d0262d3ab0a9edd5f8ecea6e2df99172275a77f324188913e"
    sha256 cellar: :any_skip_relocation, ventura:       "840f5de478b45c4683d65e2dce843fb4fcb3c34b96ba327a4165488fec803946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4d622e7908082cff720dde93dbe641a1f55e0a2b0f4e0075372e1f9373f297"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end