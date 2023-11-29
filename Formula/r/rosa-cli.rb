class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghproxy.com/https://github.com/openshift/rosa/archive/refs/tags/v1.2.31.tar.gz"
  sha256 "8cf22a34c00371ec4384c03af0ee32269e6b43272cee332dbf7e936aa0140af0"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37fc7b941a0b5345ca07840a036eecc51af6107ebe1404a709cfb9f168bf7b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e396cfdd9bf4a9b96d73e7213f58c6d619ee0d3261faa397bd149e7177bb84a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cce59ec3218457fb86d8411ca0ec49600ccb013c702b29093b7e16888c0062b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdbf4d148075f947499d341496680a69a850d6a605c7df90bca571011df9e1bd"
    sha256 cellar: :any_skip_relocation, ventura:        "3a6b26fc4af8da893e6a96eddcdb10842077ff330f558e7fea685565b7f358e4"
    sha256 cellar: :any_skip_relocation, monterey:       "efe22aa8724adf4cd1ecc313a447ab75d922b68067d13114a774bafa808a8f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74427200af75559c57390ca9199d9fc51ea8fcfccfe5bf488fdc822da3d57781"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end