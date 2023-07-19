class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghproxy.com/https://github.com/openshift/rosa/archive/refs/tags/v1.2.24.tar.gz"
  sha256 "a7d428ed3288b4c67df69346f0e7f1fbdb61c6abda9e8dafb15023f47cb24529"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "171e3496da9bea3fec35226647ab204d9d6e75b0113fde6e82c717c84b63fcb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "171e3496da9bea3fec35226647ab204d9d6e75b0113fde6e82c717c84b63fcb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "171e3496da9bea3fec35226647ab204d9d6e75b0113fde6e82c717c84b63fcb9"
    sha256 cellar: :any_skip_relocation, ventura:        "2db5e863296ced2f399811020bfe6bb6d9b239c612db68c3656c16265073a6fc"
    sha256 cellar: :any_skip_relocation, monterey:       "2db5e863296ced2f399811020bfe6bb6d9b239c612db68c3656c16265073a6fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db5e863296ced2f399811020bfe6bb6d9b239c612db68c3656c16265073a6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6209eb0da6c441888c2e70e915060090fc99baedef2ed76b12fd946946a55c0d"
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