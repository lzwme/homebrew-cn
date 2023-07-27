class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.112",
      revision: "46429a0c24a0f53d2469b105f52529ca93f31a20"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "620cf6c264e26c7dda2b2a0d449539888b93ced9d7f835aeb0bb5ef847c5b9b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "620cf6c264e26c7dda2b2a0d449539888b93ced9d7f835aeb0bb5ef847c5b9b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "620cf6c264e26c7dda2b2a0d449539888b93ced9d7f835aeb0bb5ef847c5b9b8"
    sha256 cellar: :any_skip_relocation, ventura:        "91ff51c377dfe105b38d028c2f95c0cb20a9520e65295b442d17212b90cd0377"
    sha256 cellar: :any_skip_relocation, monterey:       "91ff51c377dfe105b38d028c2f95c0cb20a9520e65295b442d17212b90cd0377"
    sha256 cellar: :any_skip_relocation, big_sur:        "91ff51c377dfe105b38d028c2f95c0cb20a9520e65295b442d17212b90cd0377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a51a11bd7e44d39e0105918e05aef4118ecb2ec0e3d22aa030476805946ee6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end