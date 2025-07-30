class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghfast.top/https://github.com/openshift/rosa/archive/refs/tags/v1.2.55.tar.gz"
  sha256 "ec75bed1372719d490ab2b3ca897eb633cb2d56d64ba99b537c6a7c9e2fa3386"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f804fbc24de26ac51beeec0a1478f1e5f878883cbfa122c4f91c4bb5b80b6bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6698f4cd40fbad529bdcb3e9cf37af2f1ef607ca860d0a2de0def35ff9580cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf49cb512ecf85c1aa829abfa5eaf9a33c4140376f62e7d471e25542c00da3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2cc5c52da66f41993c9558d3b381654bcc73fedc67a58c1ad733a045cfd555"
    sha256 cellar: :any_skip_relocation, ventura:       "549d8c4d43956dbb2d7906468d4957c8960e13cb4775332e959941046743f1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512fce2cb3e77334f8a7dd3d3e6d64b887d9ea036a46b7c72e7c6b1567195331"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end