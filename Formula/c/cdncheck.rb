class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.22.tar.gz"
  sha256 "4ab00de59aed8d3e356e67110bd1352aec5f2ce355b4a4aefd55bede3c877bba"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4bfa85e3b66b0956d696655aa1e8f245631825744a5721e2711473b06675544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995db71f5d8847b1f5a5676dd92a93a9bf901fa4a48f42ef19428e4b09d5d81c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b9ebcfa11b08bec5dc24b857eb68fef7855574e12ad8f603ee685ad6bbebbcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "881b8652fd12322fafd2bf2eff44e6d0f43ee32bf1e11e31ab5b7cce1fff5c30"
    sha256 cellar: :any_skip_relocation, ventura:       "29cf6c3ae702d2ff91a2da90edb3aae8a063f763d45d8a43ba366a93568125ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670fd341a1fdc0f8f12cdc1dc951f823d5e38dbc9a89713010ea21ec07d0cc79"
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